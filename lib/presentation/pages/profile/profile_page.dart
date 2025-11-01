import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/group/group_bloc.dart';
import '../../../bloc/settings/settings_bloc.dart';
import '../../../bloc/settings/settings_event.dart';
import '../../../bloc/settings/settings_state.dart';
import '../../../bloc/balance/balance_bloc.dart';
import '../../../../domain/entities/user.dart';
import '../../../../core/config/app_config.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../login/login_page.dart';
import '../categories/category_management_page.dart';
import '../groups/group_management_page.dart';
import '../balance/balance_page.dart';
import 'app_info_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 프로필 조회
    context.read<AuthBloc>().add(const ProfileRequested());
    // 설정 조회
    context.read<SettingsBloc>().add(const LoadSettings());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // 로그아웃 성공 시 로그인 페이지로 이동
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
          
          // 에러 메시지 표시
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          
          // 프로필 수정 성공 메시지
          if (state is AuthAuthenticated && state.user.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('프로필이 성공적으로 업데이트되었습니다'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is AuthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const ProfileRequested());
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }
            
            // 사용자 정보 추출
            Map<String, dynamic> userData = {};
            if (state is AuthAuthenticated) {
              userData = state.user;
            }
            
            final nickname = userData['name'] as String? ?? userData['nickname'] as String? ?? '사용자';
            final email = userData['email'] as String? ?? 'example@email.com';
            final userId = userData['id'];
            
            return ListView(
              children: [
                // 프로필 헤더
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        nickname,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // 그룹 정보
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('그룹 관리'),
                  subtitle: const Text('그룹 정보 및 멤버 관리'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<GroupBloc>(),
                          child: const GroupManagementPage(),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                
                // 설정 섹션
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '설정',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('잔액 조회'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<BalanceBloc>(),
                          child: const BalancePage(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('카테고리 관리'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<CategoryBloc>(),
                          child: const CategoryManagementPage(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('프로필 수정'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showEditProfileDialog(context, nickname, email);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.password_outlined),
                  title: const Text('비밀번호 변경'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showChangePasswordDialog(context);
                  },
                ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              bool notificationEnabled = true;
              
              if (state is SettingsLoaded) {
                notificationEnabled = state.settings['notifications']?['enabled'] as bool? ?? true;
              }
              
              return ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('알림 설정'),
                trailing: Switch(
                  value: notificationEnabled,
                  onChanged: (value) {
                    final currentSettings = state is SettingsLoaded
                        ? Map<String, dynamic>.from(state.settings)
                        : <String, dynamic>{};
                    
                    if (currentSettings['notifications'] == null) {
                      currentSettings['notifications'] = {};
                    }
                    (currentSettings['notifications'] as Map<String, dynamic>)['enabled'] = value;
                    
                    context.read<SettingsBloc>().add(UpdateSettings(currentSettings));
                  },
                ),
              );
            },
          ),
                const Divider(height: 1),
                
                // 계정 섹션
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '계정',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outlined),
                  title: const Text('앱 정보'),
                  subtitle: Text('버전 ${AppConfig.appVersion}'),
                  onTap: () {
                    _showAppInfoDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showEditProfileDialog(BuildContext context, String currentNickname, String currentEmail) {
    final nicknameController = TextEditingController(text: currentNickname);
    final emailController = TextEditingController(text: currentEmail);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                hintText: '닉네임을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일을 입력하세요',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final newNickname = nicknameController.text.trim();
              final newEmail = emailController.text.trim();
              
              if (newNickname.isNotEmpty || newEmail.isNotEmpty) {
                context.read<AuthBloc>().add(
                  ProfileUpdateRequested(
                    nickname: newNickname.isNotEmpty ? newNickname : null,
                    email: newEmail.isNotEmpty ? newEmail : null,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
  
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('비밀번호 변경'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: '현재 비밀번호',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureCurrent = !obscureCurrent;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: '새 비밀번호',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: '새 비밀번호 확인',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;
                
                if (currentPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('현재 비밀번호를 입력해주세요')),
                  );
                  return;
                }
                
                if (newPassword.isEmpty || newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('새 비밀번호는 최소 6자 이상이어야 합니다')),
                  );
                  return;
                }
                
                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다')),
                  );
                  return;
                }
                
                context.read<AuthBloc>().add(
                  ChangePasswordRequested(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('변경'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AppInfoDialog(),
    );
  }
}

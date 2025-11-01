import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../core/utils/dependency_injection.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _resetToken; // 개발 환경용 토큰 저장
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(email: _emailController.text.trim()),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DependencyInjection.createAuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            setState(() {
              _resetToken = state.token; // 개발 환경용
            });
            
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('이메일 전송 완료'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.message),
                    if (state.token != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        '개발 환경: 아래 토큰을 사용하여 비밀번호를 재설정할 수 있습니다.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        state.token!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                    if (state.token != null)
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                          // TODO: 비밀번호 리셋 페이지 구현 후 연결
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   '/reset-password',
                          //   arguments: {'token': state.token},
                          // );
                        },
                        child: const Text('비밀번호 재설정'),
                      ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pop(context); // 페이지 닫기
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: _buildBody(context),
      ),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                
                // 아이콘
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                
                // 설명
                Text(
                  '비밀번호 찾기',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                Text(
                  '등록된 이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // 이메일 입력
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    if (!value.contains('@')) {
                      return '올바른 이메일 형식이 아닙니다';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // 제출 버튼
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Text('이메일 전송'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // 로그인으로 돌아가기
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('로그인으로 돌아가기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


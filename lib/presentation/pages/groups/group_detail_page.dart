import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/group/group_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';

class GroupDetailPage extends StatefulWidget {
  final Map<String, dynamic> group;
  
  const GroupDetailPage({
    super.key,
    required this.group,
  });
  
  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  String? _inviteCode;
  bool _isLoadingInviteCode = false;
  
  @override
  void initState() {
    super.initState();
    // BLoC 리스너 추가
    context.read<GroupBloc>().stream.listen((state) {
      if (state is InviteCodeGenerated) {
        setState(() {
          _inviteCode = state.inviteCode;
          _isLoadingInviteCode = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final groupName = widget.group['name'] as String? ?? '그룹';
    final memberCount = widget.group['member_count'] as int? ?? 0;
    final groupId = widget.group['id'] as int? ?? 0;
    final isOwner = widget.group['is_owner'] as bool? ?? false;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context);
              },
            ),
        ],
      ),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('삭제') || state.message.contains('나가기')) {
              Navigator.pop(context);
            }
          }
          if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 정보 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '그룹 정보',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.group),
                        title: const Text('그룹 이름'),
                        trailing: Text(
                          groupName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.people),
                        title: const Text('멤버 수'),
                        trailing: Text(
                          '$memberCount명',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 초대 코드 섹션
              if (isOwner) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '초대 코드',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        if (_inviteCode != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _inviteCode!,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _inviteCode!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('초대 코드가 클립보드에 복사되었습니다'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '이 코드를 공유하여 그룹에 초대하세요',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ] else ...[
                          ElevatedButton.icon(
                            onPressed: _isLoadingInviteCode
                                ? null
                                : () {
                                    setState(() {
                                      _isLoadingInviteCode = true;
                                    });
                                    context.read<GroupBloc>().add(
                                      GenerateInviteCodeRequested(groupId: groupId),
                                    );
                                  },
                            icon: _isLoadingInviteCode
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.code),
                            label: const Text('초대 코드 생성'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // 그룹 참가 섹션
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '그룹 참가',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const Text('초대 코드를 입력하여 그룹에 참가하세요'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showJoinDialog(context);
                        },
                        icon: const Icon(Icons.group_add),
                        label: const Text('그룹 참가'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 그룹 관리 섹션
              Card(
                child: Column(
                  children: [
                    if (isOwner) ...[
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('그룹 이름 수정'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _showEditDialog(context);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        title: Text(
                          '그룹 삭제',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onTap: () {
                          _showDeleteDialog(context);
                        },
                      ),
                    ] else ...[
                      ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        title: Text(
                          '그룹 나가기',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onTap: () {
                          _showLeaveDialog(context);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(
      text: widget.group['name'] as String? ?? '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 이름 수정'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '그룹 이름',
            hintText: '그룹 이름을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<GroupBloc>().add(
                  UpdateGroupRequested(
                    groupId: widget.group['id'] as int,
                    name: nameController.text.trim(),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 삭제'),
        content: const Text('정말 이 그룹을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GroupBloc>().add(
                DeleteGroupRequested(groupId: widget.group['id'] as int),
              );
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 나가기'),
        content: const Text('정말 이 그룹에서 나가시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GroupBloc>().add(const LeaveGroupRequested());
            },
            child: Text(
              '나가기',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showJoinDialog(BuildContext context) {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 참가'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: '초대 코드',
            hintText: '초대 코드를 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (codeController.text.trim().isNotEmpty) {
                context.read<GroupBloc>().add(
                  JoinGroupRequested(inviteCode: codeController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('참가'),
          ),
        ],
      ),
    );
  }
}


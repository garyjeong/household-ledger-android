import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/group/group_bloc.dart';
import '../../../bloc/group/group_event.dart';
import '../../../bloc/group/group_state.dart';
import 'group_detail_page.dart';

class GroupManagementPage extends StatefulWidget {
  const GroupManagementPage({super.key});
  
  @override
  State<GroupManagementPage> createState() => _GroupManagementPageState();
}

class _GroupManagementPageState extends State<GroupManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(const LoadGroups());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 관리'),
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
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
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is GroupError) {
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
                      context.read<GroupBloc>().add(const LoadGroups());
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          
          if (state is GroupsLoaded) {
            final groups = state.groups;
            
            if (groups.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '그룹이 없습니다',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCreateDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('그룹 생성'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GroupBloc>().add(const LoadGroups());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: groups.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _GroupCard(
                    group: group,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<GroupBloc>(),
                            child: GroupDetailPage(group: group),
                          ),
                        ),
                      ).then((_) {
                        // 그룹 상세에서 돌아온 후 목록 새로고침
                        context.read<GroupBloc>().add(const LoadGroups());
                      });
                    },
                  );
                },
              ),
            );
          }
          
          return const Center(child: Text('그룹을 불러오는 중...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('그룹 생성'),
      ),
    );
  }
  
  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 생성'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '그룹 이름',
            hintText: '예: 우리 가족',
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
                  CreateGroupRequested(name: nameController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }
}

/// 그룹 카드 위젯
class _GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final VoidCallback onTap;
  
  const _GroupCard({
    required this.group,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final groupName = group['name'] as String? ?? '그룹';
    final memberCount = group['member_count'] as int? ?? 0;
    final isOwner = group['is_owner'] as bool? ?? false;
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.group,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(groupName),
        subtitle: Text('멤버 ${memberCount}명'),
        trailing: isOwner
            ? Chip(
                label: const Text('그룹장'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}


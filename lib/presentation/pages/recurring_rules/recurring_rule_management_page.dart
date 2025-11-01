import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recurring_rule/recurring_rule_bloc.dart';
import '../../bloc/recurring_rule/recurring_rule_event.dart';
import '../../bloc/recurring_rule/recurring_rule_state.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import 'recurring_rule_form_modal.dart';
import 'recurring_rule_detail_page.dart';

class RecurringRuleManagementPage extends StatefulWidget {
  const RecurringRuleManagementPage({super.key});
  
  @override
  State<RecurringRuleManagementPage> createState() => _RecurringRuleManagementPageState();
}

class _RecurringRuleManagementPageState extends State<RecurringRuleManagementPage> {
  bool _showActiveOnly = false;
  
  @override
  void initState() {
    super.initState();
    _loadRecurringRules();
    // 카테고리 로드
    context.read<CategoryBloc>().add(const LoadCategories());
  }
  
  void _loadRecurringRules() {
    context.read<RecurringRuleBloc>().add(
      LoadRecurringRules(
        isActive: _showActiveOnly ? true : null,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반복 규칙 관리'),
        actions: [
          Switch(
            value: _showActiveOnly,
            onChanged: (value) {
              setState(() {
                _showActiveOnly = value;
              });
              _loadRecurringRules();
            },
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              _showActiveOnly ? '활성만' : '전체',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      body: BlocConsumer<RecurringRuleBloc, RecurringRuleState>(
        listener: (context, state) {
          if (state is RecurringRuleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadRecurringRules();
          }
          if (state is RecurringRuleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RecurringRuleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RecurringRuleError) {
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
                      _loadRecurringRules();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          
          if (state is RecurringRulesLoaded) {
            final rules = state.rules;
            
            if (rules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.repeat_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '반복 규칙이 없습니다',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showRuleFormModal(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('반복 규칙 추가'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                _loadRecurringRules();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rules.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return _RecurringRuleCard(
                    rule: rule,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<RecurringRuleBloc>(),
                            child: RecurringRuleDetailPage(
                              rule: rule,
                            ),
                          ),
                        ),
                      ).then((_) {
                        _loadRecurringRules();
                      });
                    },
                    onEdit: () {
                      _showRuleFormModal(context, rule: rule);
                    },
                  );
                },
              ),
            );
          }
          
          return const Center(child: Text('반복 규칙을 불러오는 중...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showRuleFormModal(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('반복 규칙 추가'),
      ),
    );
  }
  
  void _showRuleFormModal(BuildContext context, {Map<String, dynamic>? rule}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<RecurringRuleBloc, RecurringRuleState>(
        listener: (context, state) {
          if (state is RecurringRuleSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadRecurringRules();
          }
        },
        child: BlocProvider.value(
          value: context.read<RecurringRuleBloc>(),
          child: BlocBuilder<RecurringRuleBloc, RecurringRuleState>(
            builder: (context, state) {
              return RecurringRuleFormModal(
                initialRule: rule,
                onSave: (data) {
                  if (rule == null) {
                    context.read<RecurringRuleBloc>().add(CreateRecurringRule(data));
                  } else {
                    final ruleId = rule['id']?.toString() ?? '';
                    context.read<RecurringRuleBloc>().add(UpdateRecurringRule(ruleId, data));
                  }
                },
                isLoading: state is RecurringRuleLoading,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 반복 규칙 카드 위젯
class _RecurringRuleCard extends StatelessWidget {
  final Map<String, dynamic> rule;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  
  const _RecurringRuleCard({
    required this.rule,
    required this.onTap,
    this.onEdit,
  });
  
  @override
  Widget build(BuildContext context) {
    final frequency = rule['frequency'] as String? ?? '';
    final dayRule = rule['day_rule'] as String? ?? '';
    final amount = rule['amount'] as int? ?? 0;
    final isActive = rule['is_active'] as bool? ?? true;
    final category = rule['category'] as Map<String, dynamic>?;
    final memo = rule['memo'] as String?;
    final merchant = rule['merchant'] as String?;
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.repeat,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          _formatFrequency(frequency, dayRule),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatAmount(amount)}원',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (category != null)
              Text(
                category['name'] as String? ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (merchant != null && merchant.isNotEmpty)
              Text(
                merchant,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (memo != null && memo.isNotEmpty)
              Text(
                memo,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                isActive ? '활성' : '비활성',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              backgroundColor: isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }
  
  String _formatFrequency(String frequency, String dayRule) {
    switch (frequency.toUpperCase()) {
      case 'DAILY':
        return '매일';
      case 'WEEKLY':
        return '매주 ${_formatDayOfWeek(dayRule)}';
      case 'MONTHLY':
        return '매월 ${dayRule}일';
      case 'YEARLY':
        return '매년 ${dayRule}';
      default:
        return '$frequency - $dayRule';
    }
  }
  
  String _formatDayOfWeek(String day) {
    const days = {
      'MON': '월요일',
      'TUE': '화요일',
      'WED': '수요일',
      'THU': '목요일',
      'FRI': '금요일',
      'SAT': '토요일',
      'SUN': '일요일',
    };
    return days[day.toUpperCase()] ?? day;
  }
  
  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toString();
  }
}


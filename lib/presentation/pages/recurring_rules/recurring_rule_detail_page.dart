import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/recurring_rule/recurring_rule_bloc.dart';
import '../../bloc/recurring_rule/recurring_rule_event.dart';
import '../../bloc/recurring_rule/recurring_rule_state.dart';
import 'recurring_rule_form_modal.dart';

class RecurringRuleDetailPage extends StatelessWidget {
  final Map<String, dynamic> rule;
  
  const RecurringRuleDetailPage({
    super.key,
    required this.rule,
  });
  
  @override
  Widget build(BuildContext context) {
    final frequency = rule['frequency'] as String? ?? '';
    final dayRule = rule['day_rule'] as String? ?? '';
    final amount = rule['amount'] as int? ?? 0;
    final category = rule['category'] as Map<String, dynamic>?;
    final merchant = rule['merchant'] as String?;
    final memo = rule['memo'] as String?;
    final isActive = rule['is_active'] as bool? ?? true;
    final startDate = rule['start_date'] as String? ?? '';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('반복 규칙 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditModal(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: BlocListener<RecurringRuleBloc, RecurringRuleState>(
        listener: (context, state) {
          if (state is RecurringRuleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('삭제')) {
              Navigator.pop(context);
            }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 규칙 정보 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '규칙 정보',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.repeat),
                        title: const Text('빈도'),
                        trailing: Text(
                          _formatFrequency(frequency, dayRule),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('금액'),
                        trailing: Text(
                          '${_formatAmount(amount)}원',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('시작일'),
                        trailing: Text(
                          _formatDate(startDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (category != null) ...[
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.category),
                          title: const Text('카테고리'),
                          trailing: Text(
                            category['name'] as String? ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                      if (merchant != null && merchant.isNotEmpty) ...[
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.store),
                          title: const Text('가맹점'),
                          trailing: Text(
                            merchant,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                      if (memo != null && memo.isNotEmpty) ...[
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.note),
                          title: const Text('메모'),
                          subtitle: Text(
                            memo,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.info),
                        title: const Text('상태'),
                        trailing: Chip(
                          label: Text(
                            isActive ? '활성' : '비활성',
                          ),
                          backgroundColor: isActive
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 액션 버튼
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _showGenerateDialog(context);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('거래 생성'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<RecurringRuleBloc>().add(
                            const ProcessRecurringRules(),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('규칙 처리'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<RecurringRuleBloc, RecurringRuleState>(
        listener: (context, state) {
          if (state is RecurringRuleSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: BlocProvider.value(
          value: context.read<RecurringRuleBloc>(),
          child: BlocBuilder<RecurringRuleBloc, RecurringRuleState>(
            builder: (context, state) {
              return RecurringRuleFormModal(
                initialRule: rule,
                onSave: (data) {
                  final ruleId = rule['id']?.toString() ?? '';
                  context.read<RecurringRuleBloc>().add(UpdateRecurringRule(ruleId, data));
                },
                isLoading: state is RecurringRuleLoading,
              );
            },
          ),
        ),
      ),
    );
  }
  
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('반복 규칙 삭제'),
        content: const Text('정말 이 반복 규칙을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final ruleId = rule['id']?.toString() ?? '';
              context.read<RecurringRuleBloc>().add(DeleteRecurringRule(ruleId));
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
  
  void _showGenerateDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('거래 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('거래를 생성할 날짜를 선택하세요'),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  DateFormat('yyyy년 MM월 dd일').format(selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedDate = picked;
                    });
                  }
                },
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
                Navigator.pop(context);
                final ruleId = rule['id']?.toString() ?? '';
                final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                context.read<RecurringRuleBloc>().add(
                  GenerateTransactionFromRule(ruleId, date: dateStr),
                );
              },
              child: const Text('생성'),
            ),
          ],
        ),
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
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy년 MM월 dd일').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}


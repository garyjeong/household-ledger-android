import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../bloc/budget/budget_bloc.dart';
import '../../../bloc/budget/budget_event.dart';
import '../../../bloc/budget/budget_state.dart';

class BudgetDetailPage extends StatefulWidget {
  final Map<String, dynamic> budget;
  final String ownerType;
  
  const BudgetDetailPage({
    super.key,
    required this.budget,
    required this.ownerType,
  });
  
  @override
  State<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {
  Map<String, dynamic>? _budgetStatus;
  bool _isLoadingStatus = false;
  
  @override
  void initState() {
    super.initState();
    _loadBudgetStatus();
  }
  
  void _loadBudgetStatus() {
    final period = widget.budget['period'] as String? ?? '';
    if (period.isNotEmpty) {
      setState(() {
        _isLoadingStatus = true;
      });
      
      context.read<BudgetBloc>().add(
        LoadBudgetStatus(
          ownerType: widget.ownerType,
          period: period,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final period = widget.budget['period'] as String? ?? '';
    final totalAmount = widget.budget['total_amount'] as int? ?? 0;
    final status = widget.budget['status'] as String? ?? 'ACTIVE';
    final formattedPeriod = _formatPeriod(period);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedPeriod),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(context);
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
      body: BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetStatusLoaded) {
            setState(() {
              _budgetStatus = state.status;
              _isLoadingStatus = false;
            });
          }
          if (state is BudgetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('삭제')) {
              Navigator.pop(context);
            } else {
              _loadBudgetStatus();
            }
          }
          if (state is BudgetError) {
            setState(() {
              _isLoadingStatus = false;
            });
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
              // 예산 정보 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '예산 정보',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('예산 금액'),
                        trailing: Text(
                          _formatAmount(totalAmount),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('기간'),
                        trailing: Text(
                          formattedPeriod,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.info),
                        title: const Text('상태'),
                        trailing: Chip(
                          label: Text(
                            status == 'ACTIVE' ? '활성' : '비활성',
                          ),
                          backgroundColor: status == 'ACTIVE'
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 예산 현황 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '예산 현황',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingStatus) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (_budgetStatus != null) ...[
                        _buildStatusCard(context),
                      ] else ...[
                        const Center(
                          child: Text('예산 현황을 불러올 수 없습니다'),
                        ),
                      ],
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
  
  Widget _buildStatusCard(BuildContext context) {
    final budgetStatus = _budgetStatus!;
    final totalBudget = budgetStatus['total_budget'] as int? ?? 0;
    final totalSpent = budgetStatus['total_spent'] as int? ?? 0;
    final remaining = budgetStatus['remaining_budget'] as int? ?? 0;
    final usagePercent = budgetStatus['usage_percent'] as double? ?? 0.0;
    final categoryBreakdown = budgetStatus['category_breakdown'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 전체 현황
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '예산',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatAmount(totalBudget),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '사용',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatAmount(totalSpent),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '잔액',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatAmount(remaining),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: remaining >= 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 사용률 프로그레스 바
        LinearProgressIndicator(
          value: usagePercent / 100,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(
            usagePercent > 100
                ? Theme.of(context).colorScheme.error
                : usagePercent > 80
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '사용률: ${usagePercent.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        
        // 카테고리별 현황
        if (categoryBreakdown.isNotEmpty) ...[
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            '카테고리별 현황',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...categoryBreakdown.map((item) {
            final categoryName = item['category_name'] as String? ?? '';
            final budget = item['budget'] as int? ?? 0;
            final spent = item['spent'] as int? ?? 0;
            final usage = item['usage_percent'] as double? ?? 0.0;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${usage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (usage / 100).clamp(0.0, 1.0),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '예산: ${_formatAmount(budget)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '사용: ${_formatAmount(spent)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }
  
  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: BlocProvider.value(
          value: context.read<BudgetBloc>(),
          child: BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              return BudgetFormModal(
                initialBudget: widget.budget,
                ownerType: widget.ownerType,
                onSave: (data) {
                  context.read<BudgetBloc>().add(CreateOrUpdateBudget(data));
                },
                isLoading: state is BudgetLoading,
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
        title: const Text('예산 삭제'),
        content: const Text('정말 이 예산을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final budgetId = widget.budget['id']?.toString() ?? '';
              context.read<BudgetBloc>().add(DeleteBudget(budgetId));
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
  
  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toString();
  }
  
  String _formatPeriod(String period) {
    try {
      final date = DateFormat('yyyy-MM').parse(period);
      return '${date.year}년 ${date.month}월';
    } catch (e) {
      return period;
    }
  }
}


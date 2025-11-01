import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../bloc/budget/budget_bloc.dart';
import '../../../bloc/budget/budget_event.dart';
import '../../../bloc/budget/budget_state.dart';
import 'budget_form_modal.dart';
import 'budget_detail_page.dart';

class BudgetManagementPage extends StatefulWidget {
  const BudgetManagementPage({super.key});
  
  @override
  State<BudgetManagementPage> createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedOwnerType = 'USER';
  DateTime _selectedPeriod = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadBudgets();
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }
  
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _selectedOwnerType = _tabController.index == 0 ? 'USER' : 'GROUP';
      });
      _loadBudgets();
    }
  }
  
  void _loadBudgets() {
    context.read<BudgetBloc>().add(
      LoadBudgets(ownerType: _selectedOwnerType),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예산 관리'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '개인 예산'),
            Tab(text: '그룹 예산'),
          ],
        ),
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadBudgets();
          }
          if (state is BudgetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is BudgetError) {
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
                      _loadBudgets();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          
          if (state is BudgetsLoaded) {
            final budgets = state.budgets;
            
            if (budgets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '예산이 없습니다',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showBudgetFormModal(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('예산 추가'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                _loadBudgets();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: budgets.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return _BudgetCard(
                    budget: budget,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<BudgetBloc>(),
                            child: BudgetDetailPage(
                              budget: budget,
                              ownerType: _selectedOwnerType,
                            ),
                          ),
                        ),
                      ).then((_) {
                        _loadBudgets();
                      });
                    },
                    onEdit: () {
                      _showBudgetFormModal(context, budget: budget);
                    },
                  );
                },
              ),
            );
          }
          
          return const Center(child: Text('예산을 불러오는 중...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showBudgetFormModal(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('예산 추가'),
      ),
    );
  }
  
  void _showBudgetFormModal(BuildContext context, {Map<String, dynamic>? budget}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadBudgets();
          }
        },
        child: BlocProvider.value(
          value: context.read<BudgetBloc>(),
          child: BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              return BudgetFormModal(
                initialBudget: budget,
                ownerType: _selectedOwnerType,
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
}

/// 예산 카드 위젯
class _BudgetCard extends StatelessWidget {
  final Map<String, dynamic> budget;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  
  const _BudgetCard({
    required this.budget,
    required this.onTap,
    this.onEdit,
  });
  
  @override
  Widget build(BuildContext context) {
    final period = budget['period'] as String? ?? '';
    final totalAmount = budget['total_amount'] as int? ?? 0;
    final status = budget['status'] as String? ?? 'ACTIVE';
    final formattedAmount = _formatAmount(totalAmount);
    final formattedPeriod = _formatPeriod(period);
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: status == 'ACTIVE'
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.account_balance_wallet,
            color: status == 'ACTIVE'
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          formattedPeriod,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '예산: ${formattedAmount}원',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                status == 'ACTIVE' ? '활성' : '비활성',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              backgroundColor: status == 'ACTIVE'
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


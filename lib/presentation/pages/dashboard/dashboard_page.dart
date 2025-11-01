import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../bloc/statistics/statistics_bloc.dart';
import '../../bloc/statistics/statistics_event.dart';
import '../../bloc/statistics/statistics_state.dart';
import '../../../../core/utils/dependency_injection.dart';
import '../../../../domain/entities/transaction.dart';
import '../transactions/quick_add_modal.dart';
import '../transactions/transaction_detail_page.dart';
import '../profile/profile_page.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 데이터 조회
    _loadData();
  }
  
  void _loadData() {
    final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    
    context.read<TransactionBloc>().add(
      LoadTransactions(
        startDate: startDate.toIso8601String().split('T')[0],
        endDate: endDate.toIso8601String().split('T')[0],
      ),
    );
    
    context.read<StatisticsBloc>().add(
      LoadStatistics(
        startDate: startDate.toIso8601String().split('T')[0],
        endDate: endDate.toIso8601String().split('T')[0],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대시보드'),
        actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월 선택기
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                    });
                    _loadData();
                  },
                ),
                Text(
                  '${_selectedDate.year}년 ${_selectedDate.month}월',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                    });
                    _loadData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 요약 카드 (통계 데이터 사용)
            BlocBuilder<StatisticsBloc, StatisticsState>(
              builder: (context, statsState) {
                if (statsState is StatisticsLoaded) {
                  final stats = statsState.data;
                  final totalIncome = (stats['summary']?['total_income'] as num?)?.toInt() ?? 0;
                  final totalExpense = (stats['summary']?['total_expense'] as num?)?.toInt() ?? 0;
                  
                  return Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: '수입',
                          amount: totalIncome,
                          icon: Icons.trending_up,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: '지출',
                          amount: totalExpense,
                          icon: Icons.trending_down,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                }
                
                // 로딩 또는 기본값
                return Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: '수입',
                        amount: 0,
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryCard(
                        title: '지출',
                        amount: 0,
                        icon: Icons.trending_down,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            
            // 최근 거래
            Text(
              '최근 거래',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                // 성공 메시지 표시
                if (state is TransactionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadData(); // 데이터 새로고침
                }
                
                // 에러 메시지 표시
                if (state is TransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is TransactionError) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is TransactionsLoaded) {
                  final transactions = state.transactions.take(5).toList();
                  
                  if (transactions.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '아직 거래가 없습니다',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: transactions.map((transaction) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.category,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            transaction.memo ?? transaction.merchant ?? '거래',
                          ),
                          subtitle: Text(
                            _formatDate(transaction.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Text(
                            _formatAmount(transaction),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: transaction.type == 'EXPENSE'
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: context.read<TransactionBloc>(),
                                  child: TransactionDetailPage(
                                    transaction: transaction,
                                  ),
                                ),
                              ),
                            ).then((_) {
                              _loadData(); // 상세 페이지에서 돌아온 후 데이터 새로고침
                            });
                          },
                        ),
                      );
                    }).take(5).toList(),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showQuickAddModal(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('거래 입력'),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
  
  void _showQuickAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadData(); // 데이터 새로고침
          }
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocProvider.value(
          value: context.read<TransactionBloc>(),
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return QuickAddModal(
                onSave: (data) {
                  context.read<TransactionBloc>().add(CreateTransaction(data));
                },
                isLoading: state is TransactionLoading,
              );
            },
          ),
        ),
      ),
    );
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
  
  String _formatAmount(Transaction transaction) {
    final amount = int.tryParse(transaction.amount) ?? 0;
    final isExpense = transaction.type == 'EXPENSE';
    final prefix = isExpense ? '-' : '+';
    
    if (amount >= 1000000) {
      return '$prefix${(amount / 1000000).toStringAsFixed(1)}M원';
    } else if (amount >= 1000) {
      return '$prefix${(amount / 1000).toStringAsFixed(0)}k원';
    }
    return '$prefix$amount원';
  }
}

/// 요약 카드 위젯
class _SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final IconData icon;
  final Color color;
  
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatAmount(amount),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M원';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k원';
    }
    return '$amount원';
  }
}

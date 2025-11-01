import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../bloc/balance/balance_bloc.dart';
import '../../../bloc/balance/balance_event.dart';
import '../../../bloc/balance/balance_state.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});
  
  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  int? _selectedGroupId;
  bool _includeProjection = false;
  int _projectionMonths = 3;
  String? _selectedPeriod;
  
  @override
  void initState() {
    super.initState();
    _loadBalance();
  }
  
  void _loadBalance() {
    context.read<BalanceBloc>().add(
      LoadBalance(
        groupId: _selectedGroupId,
        includeProjection: _includeProjection,
        projectionMonths: _projectionMonths,
        period: _selectedPeriod,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('잔액 조회'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) {
          if (state is BalanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is BalanceError) {
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
                      _loadBalance();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          
          if (state is BalanceLoaded) {
            final balance = state.balance;
            final balanceData = balance['balance'] as Map<String, dynamic>? ?? {};
            final periodData = balance['period_data'] as Map<String, dynamic>?;
            final monthlyTrend = balance['monthly_trend'] as List<dynamic>?;
            
            return RefreshIndicator(
              onRefresh: () async {
                _loadBalance();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 잔액 카드
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '현재 잔액',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_formatAmount(balanceData['current_balance'] as int? ?? 0)}원',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: (balanceData['current_balance'] as int? ?? 0) >= 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                            if (balanceData['projected_balance'] != null) ...[
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              Text(
                                '예상 잔액',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_formatAmount(balanceData['projected_balance'] as int? ?? 0)}원',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: (balanceData['projected_balance'] as int? ?? 0) >= 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 기간 데이터
                    if (periodData != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '기간별 요약',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '수입',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(
                                        '${_formatAmount(periodData['total_income'] as int? ?? 0)}원',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '지출',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(
                                        '${_formatAmount(periodData['total_expense'] as int? ?? 0)}원',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '순수익',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(
                                        '${_formatAmount((periodData['total_income'] as int? ?? 0) - (periodData['total_expense'] as int? ?? 0))}원',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: ((periodData['total_income'] as int? ?? 0) - (periodData['total_expense'] as int? ?? 0)) >= 0
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 월별 추이
                    if (monthlyTrend != null && monthlyTrend.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '월별 추이',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: monthlyTrend.length,
                                  itemBuilder: (context, index) {
                                    final item = monthlyTrend[index] as Map<String, dynamic>;
                                    final period = item['period'] as String? ?? '';
                                    final balance = item['balance'] as int? ?? 0;
                                    
                                    return Container(
                                      width: 80,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatAmount(balance),
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          const SizedBox(height: 4),
                                          Expanded(
                                            child: Container(
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: balance >= 0
                                                    ? Theme.of(context).colorScheme.primary
                                                    : Theme.of(context).colorScheme.error,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            period.length >= 7 ? period.substring(5) : period,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          
          return const Center(child: Text('잔액을 불러오는 중...'));
        },
      ),
    );
  }
  
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('필터 설정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  title: const Text('예상 잔액 포함'),
                  value: _includeProjection,
                  onChanged: (value) {
                    setDialogState(() {
                      _includeProjection = value ?? false;
                    });
                  },
                ),
                if (_includeProjection) ...[
                  const SizedBox(height: 8),
                  Text(
                    '예상 기간 (개월)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Slider(
                    value: _projectionMonths.toDouble(),
                    min: 1,
                    max: 12,
                    divisions: 11,
                    label: '$_projectionMonths개월',
                    onChanged: (value) {
                      setDialogState(() {
                        _projectionMonths = value.toInt();
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  '기간 선택 (선택)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _selectedPeriod != null
                        ? '${_selectedPeriod!.substring(0, 4)}년 ${_selectedPeriod!.substring(5)}월'
                        : '전체',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    // 월 선택
                    final now = DateTime.now();
                    final picked = await showDialog<DateTime>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('기간 선택'),
                        content: SizedBox(
                          width: double.maxFinite,
                          height: 300,
                          child: YearPicker(
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            selectedDate: _selectedPeriod != null
                                ? DateFormat('yyyy-MM').parse(_selectedPeriod!)
                                : now,
                            onChanged: (date) {
                              Navigator.pop(context, date);
                            },
                          ),
                        ),
                      ),
                    );
                    
                    if (picked != null) {
                      final monthPicked = await showDialog<int>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('월 선택'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2,
                              ),
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                final month = index + 1;
                                return InkWell(
                                  onTap: () => Navigator.pop(context, month),
                                  child: Center(
                                    child: Text('$month월'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                      
                      if (monthPicked != null) {
                        setDialogState(() {
                          _selectedPeriod = DateFormat('yyyy-MM').format(
                            DateTime(picked.year, monthPicked),
                          );
                        });
                      }
                    }
                  },
                ),
                if (_selectedPeriod != null) ...[
                  TextButton(
                    onPressed: () {
                      setDialogState(() {
                        _selectedPeriod = null;
                      });
                    },
                    child: const Text('기간 초기화'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _loadBalance();
              },
              child: const Text('적용'),
            ),
          ],
        ),
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
}


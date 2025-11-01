import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/statistics/statistics_bloc.dart';
import '../../bloc/statistics/statistics_event.dart';
import '../../bloc/statistics/statistics_state.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});
  
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'current-month';
  
  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }
  
  void _loadStatistics() {
    final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    
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
        title: const Text('통계'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StatisticsBloc>().add(const RefreshStatistics());
            },
          ),
        ],
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is StatisticsError) {
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
                      context.read<StatisticsBloc>().add(const RefreshStatistics());
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          
          if (state is StatisticsLoaded) {
            final data = state.data;
            final summary = data['summary'] as Map<String, dynamic>? ?? {};
            final categoryStats = data['category_statistics'] as List<dynamic>? ?? [];
            final dailyTrend = data['daily_trend'] as List<dynamic>? ?? [];
            
            final totalIncome = (summary['total_income'] as num?)?.toInt() ?? 0;
            final totalExpense = (summary['total_expense'] as num?)?.toInt() ?? 0;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기간 선택
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDate.year}년 ${_selectedDate.month}월',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                              });
                              _loadStatistics();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                              });
                              _loadStatistics();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 요약 카드
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: '총 수입',
                          amount: totalIncome,
                          color: Colors.green,
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: '총 지출',
                          amount: totalExpense,
                          color: Colors.red,
                          icon: Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 지출 카테고리별 차트
                  if (categoryStats.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '지출 카테고리별 분석',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: _buildPieChartSections(categoryStats),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 50,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 범례
                            ...categoryStats.map((stat) {
                              final categoryName = stat['category_name'] as String? ?? '기타';
                              final amount = (stat['amount'] as num?)?.toInt() ?? 0;
                              final percentage = totalExpense > 0 
                                  ? (amount / totalExpense * 100).toStringAsFixed(1)
                                  : '0.0';
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(categoryStats.indexOf(stat)),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(categoryName),
                                    ),
                                    Text(
                                      '${_formatAmount(amount)} ($percentage%)',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // 월별 트렌드
                  if (dailyTrend.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '일별 트렌드',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          if (value.toInt() < dailyTrend.length) {
                                            final date = DateTime.parse(
                                              dailyTrend[value.toInt()]['date'] as String
                                            );
                                            return Text('${date.day}일');
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: true),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _buildLineChartSpots(dailyTrend),
                                      isCurved: true,
                                      color: Theme.of(context).colorScheme.primary,
                                      barWidth: 3,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                  minX: 0,
                                  maxX: dailyTrend.length > 0 ? (dailyTrend.length - 1).toDouble() : 1,
                                  minY: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // 데이터가 없을 때
                  if (categoryStats.isEmpty && dailyTrend.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bar_chart_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '통계 데이터가 없습니다',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          
          // Initial state
          return const Center(
            child: Text('통계 데이터를 불러오는 중...'),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
  
  List<PieChartSectionData> _buildPieChartSections(List<dynamic> categoryStats) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    
    double total = 0;
    for (var stat in categoryStats) {
      total += (stat['amount'] as num?)?.toDouble() ?? 0;
    }
    
    return categoryStats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;
      final amount = (stat['amount'] as num?)?.toDouble() ?? 0;
      final categoryName = stat['category_name'] as String? ?? '기타';
      final percentage = total > 0 ? (amount / total * 100) : 0;
      final color = colors[index % colors.length];
      
      return PieChartSectionData(
        value: amount,
        title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        color: color,
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
  
  List<FlSpot> _buildLineChartSpots(List<dynamic> dailyTrend) {
    return dailyTrend.asMap().entries.map((entry) {
      final index = entry.key;
      final trend = entry.value;
      final expense = (trend['expense'] as num?)?.toDouble() ?? 0;
      
      return FlSpot(index.toDouble(), expense);
    }).toList();
  }
  
  Color _getCategoryColor(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
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

/// 요약 카드
class _SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final Color color;
  final IconData icon;
  
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
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
                  style: Theme.of(context).textTheme.bodyMedium,
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

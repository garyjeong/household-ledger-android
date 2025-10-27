import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대시보드'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: 프로필 페이지로 이동
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
                    // TODO: 이전 달로 이동
                  },
                ),
                Text(
                  '2025년 10월',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    // TODO: 다음 달로 이동
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 요약 카드
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: '수입',
                    amount: 1000000,
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: '지출',
                    amount: 800000,
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 최근 거래
            Text(
              '최근 거래',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _TransactionList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 거래 입력 모달 표시
        },
        icon: const Icon(Icons.add),
        label: const Text('거래 입력'),
      ),
      bottomNavigationBar: _BottomNavBar(currentIndex: 0),
    );
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
              '${_formatAmount(amount)}원',
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
    return (amount / 1000).toStringAsFixed(0) + 'k';
  }
}

/// 거래 목록 위젯
class _TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: 실제 데이터로 교체
    final transactions = [
      {'title': '커피값', 'amount': 5000, 'date': '2025.10.27'},
      {'title': '점심값', 'amount': 8000, 'date': '2025.10.27'},
    ];
    
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
            title: Text(transaction['title'] as String),
            subtitle: Text(
              transaction['date'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              '${transaction['amount']}원',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: 거래 상세 페이지로 이동
            },
          ),
        );
      }).toList(),
    );
  }
}

/// 하단 네비게이션 바
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const _BottomNavBar({required this.currentIndex});
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        // TODO: 페이지 네비게이션 구현
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '홈',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: '거래내역',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: '통계',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: '내정보',
        ),
      ],
    );
  }
}


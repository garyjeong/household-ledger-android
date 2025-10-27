import 'package:flutter/material.dart';
import 'quick_add_modal.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});
  
  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  String _selectedType = 'ALL'; // ALL, EXPENSE, INCOME
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 내역'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 필터 기능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 탭
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: '전체',
                  isSelected: _selectedType == 'ALL',
                  onTap: () => setState(() => _selectedType = 'ALL'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '지출',
                  isSelected: _selectedType == 'EXPENSE',
                  onTap: () => setState(() => _selectedType = 'EXPENSE'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '수입',
                  isSelected: _selectedType == 'INCOME',
                  onTap: () => setState(() => _selectedType = 'INCOME'),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          
          // 거래 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: 새로고침 로직
              },
              child: _TransactionList(selectedType: _selectedType),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showQuickAddModal(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('거래 입력'),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
  
  void _showQuickAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickAddModal(
        onSave: (data) {
          // TODO: BLoC를 통한 거래 저장
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('거래가 저장되었습니다')),
          );
        },
      ),
    );
  }
}

/// 필터 칩 위젯
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}

/// 거래 목록 위젯
class _TransactionList extends StatelessWidget {
  final String selectedType;
  
  const _TransactionList({required this.selectedType});
  
  @override
  Widget build(BuildContext context) {
    // TODO: 실제 데이터로 교체
    final transactions = [
      {'title': '커피값', 'category': '음식', 'amount': 5000, 'date': '2025.10.27', 'type': 'EXPENSE'},
      {'title': '점심값', 'category': '음식', 'amount': 8000, 'date': '2025.10.27', 'type': 'EXPENSE'},
      {'title': '급여', 'category': '급여', 'amount': 2000000, 'date': '2025.10.25', 'type': 'INCOME'},
      {'title': '주유비', 'category': '교통', 'amount': 50000, 'date': '2025.10.26', 'type': 'EXPENSE'},
      {'title': '카페', 'category': '음식', 'amount': 6000, 'date': '2025.10.26', 'type': 'EXPENSE'},
    ];
    
    final filteredTransactions = selectedType == 'ALL'
        ? transactions
        : transactions.where((t) => t['type'] == selectedType).toList();
    
    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '거래 내역이 없습니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return Card(
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
              '${transaction['category']} | ${transaction['date']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              '${transaction['amount']}원',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: transaction['type'] == 'EXPENSE'
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: () {
              // TODO: 거래 상세 페이지로 이동
            },
          ),
        );
      },
    );
  }
}


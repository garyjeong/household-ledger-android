import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_event.dart';
import '../../../bloc/transaction/transaction_state.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/category/category_event.dart';
import '../../../bloc/category/category_state.dart';
import '../../../../core/utils/dependency_injection.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/transaction.dart';
import 'quick_add_modal.dart';
import 'transaction_detail_page.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});
  
  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  String _selectedType = 'ALL'; // ALL, EXPENSE, INCOME
  String? _searchQuery;
  String? _selectedCategoryId;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = false;
  bool _isLoadingMore = false;
  
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 거래 목록 조회
    _loadTransactions(reset: true);
    // 카테고리 로드
    context.read<CategoryBloc>().add(const LoadCategories());
    // 스크롤 리스너 추가
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_isLoadingMore) return; // 이미 로딩 중이면 무시
    
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      // 스크롤이 하단 200px 전에 도달하면 다음 페이지 로드
      _loadMoreTransactions();
    }
  }
  
  void _loadTransactions({bool reset = false}) {
    context.read<TransactionBloc>().add(
      LoadTransactions(
        type: _selectedType == 'ALL' ? null : _selectedType,
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0],
        categoryId: _selectedCategoryId,
        search: _searchQuery,
        offset: reset ? 0 : null,
        limit: AppConstants.defaultPageSize,
        loadMore: !reset,
      ),
    );
  }
  
  void _loadMoreTransactions() {
    if (_isLoadingMore) return;
    
    final currentState = context.read<TransactionBloc>().state;
    if (currentState is TransactionsLoaded && currentState.hasMore) {
      setState(() {
        _isLoadingMore = true;
      });
      
      context.read<TransactionBloc>().add(
        LoadTransactions(
          type: _selectedType == 'ALL' ? null : _selectedType,
          startDate: _startDate?.toIso8601String().split('T')[0],
          endDate: _endDate?.toIso8601String().split('T')[0],
          categoryId: _selectedCategoryId,
          search: _searchQuery,
          offset: currentState.offset + currentState.limit,
          limit: AppConstants.defaultPageSize,
          loadMore: true,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '메모 또는 가맹점 검색',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.isEmpty ? null : value;
                  });
                  _loadTransactions(reset: true);
                },
                onSubmitted: (value) {
                  setState(() {
                    _searchQuery = value.isEmpty ? null : value;
                  });
                  _loadTransactions(reset: true);
                },
              )
            : const Text('거래 내역'),
        actions: [
          if (_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearchVisible = false;
                  _searchQuery = null;
                  _searchController.clear();
                });
                _loadTransactions(reset: true);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchVisible = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
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
                  onTap: () {
                    setState(() => _selectedType = 'ALL');
                    _loadTransactions(reset: true);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '지출',
                  isSelected: _selectedType == 'EXPENSE',
                  onTap: () {
                    setState(() => _selectedType = 'EXPENSE');
                    _loadTransactions(reset: true);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '수입',
                  isSelected: _selectedType == 'INCOME',
                  onTap: () {
                    setState(() => _selectedType = 'INCOME');
                    _loadTransactions(reset: true);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // 거래 목록
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                // 성공 메시지 표시
                if (state is TransactionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // 거래 목록 새로고침
                  _loadTransactions(reset: true);
                }
                
                // 에러 메시지 표시
                if (state is TransactionError) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
                
                // 로드 완료 시 로딩 상태 해제
                if (state is TransactionsLoaded) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is TransactionError) {
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
                            _loadTransactions(reset: true);
                          },
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is TransactionsLoaded) {
                  final transactions = state.transactions;
                  
                  // 타입 필터링 (서버에서 이미 필터링되었지만 UI에서도 적용)
                  final filteredTransactions = _selectedType == 'ALL'
                      ? transactions
                      : transactions.where((t) => t.type == _selectedType).toList();
                  
                  if (filteredTransactions.isEmpty && !_isLoadingMore) {
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
                            _searchQuery != null || _selectedCategoryId != null || _startDate != null || _endDate != null
                                ? '조건에 맞는 거래가 없습니다'
                                : '거래 내역이 없습니다',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (_searchQuery != null || _selectedCategoryId != null || _startDate != null || _endDate != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = null;
                                  _selectedCategoryId = null;
                                  _startDate = null;
                                  _endDate = null;
                                  _searchController.clear();
                                });
                                _loadTransactions(reset: true);
                              },
                              child: const Text('필터 초기화'),
                            ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadTransactions(reset: true);
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTransactions.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) {
                        if (index == filteredTransactions.length - 1 && state.hasMore) {
                          return const SizedBox.shrink();
                        }
                        return const SizedBox(height: 8);
                      },
                      itemBuilder: (context, index) {
                        // 더 불러오기 인디케이터 표시
                        if (index == filteredTransactions.length) {
                          if (!state.hasMore) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: _isLoadingMore
                                  ? const CircularProgressIndicator()
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }
                        
                        final transaction = filteredTransactions[index];
                        return _TransactionCard(
                          transaction: transaction,
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
                              // 상세 페이지에서 돌아온 후 목록 새로고침
                              _loadTransactions(reset: true);
                            });
                          },
                        );
                      },
                    ),
                  );
                }
                
                // Initial state
                return const Center(
                  child: Text('거래 내역을 불러오는 중...'),
                );
              },
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
  
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('필터'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 필터
                Text(
                  '카테고리',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    if (categoryState is CategoriesLoaded) {
                      final categories = categoryState.categories
                          .where((cat) => _selectedType == 'ALL' || cat.type == _selectedType)
                          .toList();
                      
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('전체'),
                            selected: _selectedCategoryId == null,
                            onSelected: (selected) {
                              setDialogState(() {
                                _selectedCategoryId = null;
                              });
                            },
                          ),
                          ...categories.map((category) {
                            return ChoiceChip(
                              label: Text(category.name),
                              selected: _selectedCategoryId == category.id,
                              onSelected: (selected) {
                                setDialogState(() {
                                  _selectedCategoryId = selected ? category.id : null;
                                });
                              },
                            );
                          }),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 24),
                
                // 날짜 필터
                Text(
                  '날짜 범위',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() {
                              _startDate = date;
                            });
                          }
                        },
                        child: Text(
                          _startDate != null
                              ? '${_startDate!.year}.${_startDate!.month.toString().padLeft(2, '0')}.${_startDate!.day.toString().padLeft(2, '0')}'
                              : '시작일',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('~'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? (_startDate ?? DateTime.now()),
                            firstDate: _startDate ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() {
                              _endDate = date;
                            });
                          }
                        },
                        child: Text(
                          _endDate != null
                              ? '${_endDate!.year}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.day.toString().padLeft(2, '0')}'
                              : '종료일',
                        ),
                      ),
                    ),
                  ],
                ),
                if (_startDate != null || _endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () {
                        setDialogState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                      child: const Text('날짜 초기화'),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategoryId = null;
                  _startDate = null;
                  _endDate = null;
                });
                _loadTransactions(reset: true);
                Navigator.pop(context);
              },
              child: const Text('초기화'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _loadTransactions(reset: true);
              },
              child: const Text('적용'),
            ),
          ],
        ),
      ),
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
}

/// 거래 카드 위젯
class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  
  const _TransactionCard({
    required this.transaction,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'EXPENSE';
    final amount = int.tryParse(transaction.amount) ?? 0;
    final formattedAmount = _formatAmount(amount);
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.category?.color != null
              ? Color(int.parse(transaction.category!.color.replaceFirst('#', '0xFF')))
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          transaction.memo ?? transaction.merchant ?? '거래',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          _formatSubtitle(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}$formattedAmount원',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isExpense
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
  
  String _formatSubtitle() {
    final parts = <String>[];
    if (transaction.category != null) {
      parts.add(transaction.category!.name);
    }
    if (transaction.date.isNotEmpty) {
      parts.add(_formatDate(transaction.date));
    }
    return parts.join(' | ');
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
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

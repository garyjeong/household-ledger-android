import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_event.dart';
import '../../../bloc/transaction/transaction_state.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/category/category_event.dart';
import '../../../bloc/category/category_state.dart';
import '../../../../domain/entities/transaction.dart';
import 'quick_add_modal.dart';

class TransactionDetailPage extends StatefulWidget {
  final Transaction transaction;
  
  const TransactionDetailPage({
    super.key,
    required this.transaction,
  });
  
  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    // 카테고리 로드
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is! CategoriesLoaded) {
      context.read<CategoryBloc>().add(const LoadCategories());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 상세'),
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
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // 성공 시 이전 페이지로 돌아가기
            Navigator.pop(context);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 금액 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '${_getAmountPrefix()}${_formatAmount(int.tryParse(widget.transaction.amount) ?? 0)}원',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.transaction.type == 'EXPENSE'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          widget.transaction.type == 'EXPENSE' ? '지출' : '수입',
                        ),
                        backgroundColor: widget.transaction.type == 'EXPENSE'
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 상세 정보
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('카테고리'),
                      trailing: Text(
                        widget.transaction.category?.name ?? '미분류',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('날짜'),
                      trailing: Text(
                        _formatDate(widget.transaction.date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    if (widget.transaction.merchant != null && widget.transaction.merchant!.isNotEmpty) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.store),
                        title: const Text('가맹점'),
                        trailing: Text(
                          widget.transaction.merchant!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                    if (widget.transaction.memo != null && widget.transaction.memo!.isNotEmpty) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.note),
                        title: const Text('메모'),
                        subtitle: Text(
                          widget.transaction.memo!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // 메타 정보
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('생성일'),
                      trailing: Text(
                        _formatDateTime(widget.transaction.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text('수정일'),
                      trailing: Text(
                        _formatDateTime(widget.transaction.updatedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getAmountPrefix() {
    return widget.transaction.type == 'EXPENSE' ? '-' : '+';
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
      return '${date.year}년 ${date.month}월 ${date.day}일';
    } catch (e) {
      return dateStr;
    }
  }
  
  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
  
  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('거래 수정'),
        content: const Text('거래를 수정하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditModal(context);
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }
  
  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: BlocProvider.value(
          value: context.read<TransactionBloc>(),
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return QuickAddModal(
                initialTransaction: widget.transaction,
                onSave: (data) {
                  context.read<TransactionBloc>().add(
                    UpdateTransaction(widget.transaction.id, data),
                  );
                },
                isLoading: state is TransactionLoading,
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
        title: const Text('거래 삭제'),
        content: const Text('정말 이 거래를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TransactionBloc>().add(
                DeleteTransaction(widget.transaction.id),
              );
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
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../../../../domain/entities/transaction.dart';

class QuickAddModal extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;
  final bool isLoading;
  final Transaction? initialTransaction;
  
  const QuickAddModal({
    super.key,
    this.onSave,
    this.isLoading = false,
    this.initialTransaction,
  });
  
  @override
  State<QuickAddModal> createState() => _QuickAddModalState();
}

class _QuickAddModalState extends State<QuickAddModal> {
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  
  String _selectedType = 'EXPENSE'; // EXPENSE, INCOME
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    
    // 편집 모드인 경우 초기값 설정
    if (widget.initialTransaction != null) {
      _isEditMode = true;
      final transaction = widget.initialTransaction!;
      _selectedType = transaction.type;
      _selectedCategoryId = transaction.categoryId;
      _selectedDate = DateTime.tryParse(transaction.date) ?? DateTime.now();
      _amountController.text = (int.tryParse(transaction.amount) ?? 0).toString();
      _memoController.text = transaction.memo ?? '';
    }
    
    // 카테고리 로드
    context.read<CategoryBloc>().add(LoadCategories(type: _selectedType));
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    final amount = _amountController.text;
    if (amount.isEmpty || int.tryParse(amount) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금액을 입력해주세요')),
      );
      return;
    }
    
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요')),
      );
      return;
    }
    
    final data = {
      'type': _selectedType,
      'amount': int.parse(amount),
      'category_id': int.tryParse(_selectedCategoryId ?? '') ?? _selectedCategoryId,
      'date': _selectedDate.toIso8601String().split('T')[0],
      'memo': _memoController.text.isEmpty ? null : _memoController.text,
    };
    
    widget.onSave?.call(data);
  }
  
  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // 핸들바
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 헤더
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditMode ? '거래 수정' : '거래 입력',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // 내용
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // 거래 유형 선택
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'EXPENSE', label: Text('지출')),
                        ButtonSegment(value: 'INCOME', label: Text('수입')),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() {
                          _selectedType = selection.first;
                          _selectedCategoryId = null; // 카테고리 초기화
                        });
                        // 카테고리 다시 로드
                        context.read<CategoryBloc>().add(LoadCategories(type: _selectedType));
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // 금액 입력
                    Text(
                      '금액',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '50,000',
                        suffixText: '원',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 카테고리 선택
                    Text(
                      '카테고리',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (state is CategoryError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }
                        
                        if (state is CategoriesLoaded) {
                          final categories = state.categories
                              .where((cat) => cat.type == _selectedType)
                              .toList();
                          
                          if (categories.isEmpty) {
                            return Center(
                              child: Text(
                                '카테고리가 없습니다',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }
                          
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = _selectedCategoryId == category.id;
                              
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                  });
                                },
                                child: Card(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primaryContainer
                                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(
                                            int.parse(category.color.replaceFirst('#', ''), radix: 16) + 0xFF000000,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        category.name,
                                        style: Theme.of(context).textTheme.labelSmall,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // 날짜 선택
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('날짜'),
                      subtitle: Text(_selectedDate.toString().split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 8),
                    
                    // 메모 입력
                    TextField(
                      controller: _memoController,
                      decoration: const InputDecoration(
                        labelText: '메모',
                        hintText: '입력하세요 (선택)',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    
                    // 저장 버튼
                    ElevatedButton(
                      onPressed: widget.isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: widget.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditMode ? '수정하기' : '저장하기'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

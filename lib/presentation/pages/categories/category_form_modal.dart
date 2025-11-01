import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../domain/entities/transaction.dart';

class CategoryFormModal extends StatefulWidget {
  final Category? category;
  final String type;
  final Function(Map<String, dynamic>) onSave;
  
  const CategoryFormModal({
    super.key,
    this.category,
    required this.type,
    required this.onSave,
  });
  
  @override
  State<CategoryFormModal> createState() => _CategoryFormModalState();
}

class _CategoryFormModalState extends State<CategoryFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetAmountController = TextEditingController();
  Color _selectedColor = Colors.blue;
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.category != null;
    
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      if (widget.category!.budgetAmount != null) {
        _budgetAmountController.text = widget.category!.budgetAmount!.toString();
      }
      if (widget.category!.color != null) {
        _selectedColor = Color(
          int.parse(widget.category!.color!.replaceFirst('#', '0xFF')),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _budgetAmountController.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'type': widget.type,
        'color': '#${_selectedColor.value.toRadixString(16).substring(2)}',
      };
      
      if (_budgetAmountController.text.isNotEmpty) {
        final budgetAmount = int.tryParse(_budgetAmountController.text);
        if (budgetAmount != null && budgetAmount > 0) {
          data['budget_amount'] = budgetAmount;
        }
      }
      
      widget.onSave(data);
      Navigator.pop(context);
    }
  }
  
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('색상 선택'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                      _isEditMode ? '카테고리 수정' : '카테고리 추가',
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // 카테고리 타입 표시
                      Chip(
                        label: Text(
                          widget.type == 'EXPENSE' ? '지출' : 
                          widget.type == 'INCOME' ? '수입' : '이체',
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 카테고리 이름
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '카테고리 이름',
                          hintText: '예: 식비, 교통비',
                          prefixIcon: Icon(Icons.label),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '카테고리 이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // 색상 선택
                      InkWell(
                        onTap: _showColorPicker,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: '색상',
                            prefixIcon: Icon(Icons.color_lens),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 예산 금액 (선택)
                      TextFormField(
                        controller: _budgetAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '예산 금액 (선택)',
                          hintText: '50000',
                          suffixText: '원',
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final amount = int.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return '올바른 금액을 입력해주세요';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // 저장 버튼
                      ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_isEditMode ? '수정하기' : '추가하기'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


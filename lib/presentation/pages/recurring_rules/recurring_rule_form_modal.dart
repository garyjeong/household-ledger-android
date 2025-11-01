import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/category/category_state.dart';

class RecurringRuleFormModal extends StatefulWidget {
  final Map<String, dynamic>? initialRule;
  final Function(Map<String, dynamic>) onSave;
  final bool isLoading;
  
  const RecurringRuleFormModal({
    super.key,
    this.initialRule,
    required this.onSave,
    this.isLoading = false,
  });
  
  @override
  State<RecurringRuleFormModal> createState() => _RecurringRuleFormModalState();
}

class _RecurringRuleFormModalState extends State<RecurringRuleFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _memoController = TextEditingController();
  final _dayRuleController = TextEditingController();
  
  DateTime _selectedStartDate = DateTime.now();
  String _selectedFrequency = 'MONTHLY'; // DAILY, WEEKLY, MONTHLY, YEARLY
  String? _selectedCategoryId;
  bool _isActive = true;
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.initialRule != null) {
      _isEditMode = true;
      final rule = widget.initialRule!;
      _amountController.text = (rule['amount'] as int? ?? 0).toString();
      _selectedFrequency = rule['frequency'] as String? ?? 'MONTHLY';
      _dayRuleController.text = rule['day_rule'] as String? ?? '';
      _selectedCategoryId = rule['category_id']?.toString();
      _merchantController.text = rule['merchant'] as String? ?? '';
      _memoController.text = rule['memo'] as String? ?? '';
      _isActive = rule['is_active'] as bool? ?? true;
      
      // start_date 파싱
      final startDate = rule['start_date'] as String?;
      if (startDate != null && startDate.isNotEmpty) {
        try {
          _selectedStartDate = DateTime.parse(startDate);
        } catch (e) {
          _selectedStartDate = DateTime.now();
        }
      }
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _memoController.dispose();
    _dayRuleController.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final dayRule = _dayRuleController.text.trim();
      if (dayRule.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('반복 규칙을 입력해주세요')),
        );
        return;
      }
      
      final data = <String, dynamic>{
        'start_date': DateFormat('yyyy-MM-dd').format(_selectedStartDate),
        'frequency': _selectedFrequency,
        'day_rule': dayRule,
        'amount': int.parse(_amountController.text),
      };
      
      if (_selectedCategoryId != null) {
        data['category_id'] = int.parse(_selectedCategoryId!);
      }
      if (_merchantController.text.isNotEmpty) {
        data['merchant'] = _merchantController.text.trim();
      }
      if (_memoController.text.isNotEmpty) {
        data['memo'] = _memoController.text.trim();
      }
      
      if (_isEditMode) {
        data['is_active'] = _isActive;
      }
      
      widget.onSave(data);
    }
  }
  
  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }
  
  String _getDayRuleHint() {
    switch (_selectedFrequency) {
      case 'DAILY':
        return '예: 1 (항상 실행)';
      case 'WEEKLY':
        return '예: MON, TUE, WED 등';
      case 'MONTHLY':
        return '예: 1, 15, 28 (일)';
      case 'YEARLY':
        return '예: 01-15 (MM-DD)';
      default:
        return '';
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
                      _isEditMode ? '반복 규칙 수정' : '반복 규칙 추가',
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
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 시작일 선택
                          Text(
                            '시작일',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              DateFormat('yyyy년 MM월 dd일').format(_selectedStartDate),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: _selectStartDate,
                          ),
                          const SizedBox(height: 24),
                          
                          // 빈도 선택
                          Text(
                            '빈도',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'DAILY', label: Text('매일')),
                              ButtonSegment(value: 'WEEKLY', label: Text('매주')),
                              ButtonSegment(value: 'MONTHLY', label: Text('매월')),
                              ButtonSegment(value: 'YEARLY', label: Text('매년')),
                            ],
                            selected: {_selectedFrequency},
                            onSelectionChanged: (Set<String> selection) {
                              setState(() {
                                _selectedFrequency = selection.first;
                                _dayRuleController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // 반복 규칙 입력
                          Text(
                            '반복 규칙',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _dayRuleController,
                            decoration: InputDecoration(
                              hintText: _getDayRuleHint(),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '반복 규칙을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // 금액 입력
                          Text(
                            '금액',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '50,000',
                              suffixText: '원',
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '금액을 입력해주세요';
                              }
                              final amount = int.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return '올바른 금액을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // 카테고리 선택
                          Text(
                            '카테고리 (선택)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (state is CategoryError) {
                                return Center(child: Text('카테고리 로드 오류: ${state.message}'));
                              }
                              if (state is CategoriesLoaded) {
                                final categories = state.categories;
                                return DropdownButtonFormField<String>(
                                  value: _selectedCategoryId,
                                  decoration: const InputDecoration(
                                    filled: true,
                                  ),
                                  hint: const Text('카테고리 선택'),
                                  items: categories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category.id,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(category.color.substring(1), radix: 16) + 0xFF000000,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(category.name),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategoryId = value;
                                    });
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // 가맹점 입력 (선택)
                          TextFormField(
                            controller: _merchantController,
                            decoration: const InputDecoration(
                              labelText: '가맹점 (선택)',
                              hintText: '예: 편의점',
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // 메모 입력 (선택)
                          TextFormField(
                            controller: _memoController,
                            decoration: const InputDecoration(
                              labelText: '메모 (선택)',
                              hintText: '메모를 입력하세요',
                              filled: true,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          
                          // 활성 상태 (수정 모드만)
                          if (_isEditMode) ...[
                            Text(
                              '상태',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(value: true, label: Text('활성')),
                                ButtonSegment(value: false, label: Text('비활성')),
                              ],
                              selected: {_isActive},
                              onSelectionChanged: (Set<bool> selection) {
                                setState(() {
                                  _isActive = selection.first;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                          
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
                                : Text(_isEditMode ? '수정하기' : '추가하기'),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
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


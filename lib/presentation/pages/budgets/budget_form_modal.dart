import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetFormModal extends StatefulWidget {
  final Map<String, dynamic>? initialBudget;
  final String ownerType; // USER or GROUP
  final Function(Map<String, dynamic>) onSave;
  final bool isLoading;
  
  const BudgetFormModal({
    super.key,
    this.initialBudget,
    required this.ownerType,
    required this.onSave,
    this.isLoading = false,
  });
  
  @override
  State<BudgetFormModal> createState() => _BudgetFormModalState();
}

class _BudgetFormModalState extends State<BudgetFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  DateTime _selectedPeriod = DateTime.now();
  String _selectedStatus = 'ACTIVE';
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.initialBudget != null) {
      _isEditMode = true;
      final budget = widget.initialBudget!;
      _amountController.text = (budget['total_amount'] as int? ?? 0).toString();
      _selectedStatus = budget['status'] as String? ?? 'ACTIVE';
      
      // period 파싱
      final period = budget['period'] as String? ?? '';
      if (period.isNotEmpty) {
        try {
          _selectedPeriod = DateFormat('yyyy-MM').parse(period);
        } catch (e) {
          // 파싱 실패 시 현재 월 사용
          _selectedPeriod = DateTime.now();
        }
      }
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'owner_type': widget.ownerType,
        'period': DateFormat('yyyy-MM').format(_selectedPeriod),
        'total_amount': int.parse(_amountController.text),
        'status': _selectedStatus,
      };
      
      widget.onSave(data);
    }
  }
  
  Future<void> _selectPeriod() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: _selectedPeriod,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        _selectedPeriod = picked;
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
                      _isEditMode ? '예산 수정' : '예산 추가',
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
                          // 기간 선택
                          Text(
                            '기간',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${_selectedPeriod.year}년 ${_selectedPeriod.month}월',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: _selectPeriod,
                          ),
                          const SizedBox(height: 24),
                          
                          // 금액 입력
                          Text(
                            '예산 금액',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '1,000,000',
                              suffixText: '원',
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '예산 금액을 입력해주세요';
                              }
                              final amount = int.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return '올바른 금액을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // 상태 선택
                          if (_isEditMode) ...[
                            Text(
                              '상태',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(value: 'ACTIVE', label: Text('활성')),
                                ButtonSegment(value: 'INACTIVE', label: Text('비활성')),
                              ],
                              selected: {_selectedStatus},
                              onSelectionChanged: (Set<String> selection) {
                                setState(() {
                                  _selectedStatus = selection.first;
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


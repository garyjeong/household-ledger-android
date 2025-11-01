import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'recurring_rule_event.dart';
import 'recurring_rule_state.dart';
import '../../../data/repositories/recurring_rule_repository.dart';

/// 반복 규칙 BLoC
class RecurringRuleBloc extends Bloc<RecurringRuleEvent, RecurringRuleState> {
  final RecurringRuleRepository _repository;

  RecurringRuleBloc({required RecurringRuleRepository repository})
      : _repository = repository,
        super(RecurringRuleInitial()) {
    
    on<LoadRecurringRules>(_onLoadRecurringRules);
    on<LoadRecurringRule>(_onLoadRecurringRule);
    on<CreateRecurringRule>(_onCreateRecurringRule);
    on<UpdateRecurringRule>(_onUpdateRecurringRule);
    on<DeleteRecurringRule>(_onDeleteRecurringRule);
    on<ProcessRecurringRules>(_onProcessRecurringRules);
    on<GenerateTransactionFromRule>(_onGenerateTransactionFromRule);
    on<RefreshRecurringRules>(_onRefreshRecurringRules);
  }

  /// 반복 규칙 목록 조회
  Future<void> _onLoadRecurringRules(
    LoadRecurringRules event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      final rules = await _repository.getRecurringRules(
        isActive: event.isActive,
        groupId: event.groupId,
      );
      emit(RecurringRulesLoaded(rules));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 조회
  Future<void> _onLoadRecurringRule(
    LoadRecurringRule event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      final rule = await _repository.getRecurringRule(event.ruleId);
      emit(RecurringRuleLoaded(rule));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 생성
  Future<void> _onCreateRecurringRule(
    CreateRecurringRule event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      await _repository.createRecurringRule(event.data);
      emit(RecurringRuleSuccess('반복 규칙이 생성되었습니다'));
      
      // 목록 새로고침
      final rules = await _repository.getRecurringRules();
      emit(RecurringRulesLoaded(rules));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 수정
  Future<void> _onUpdateRecurringRule(
    UpdateRecurringRule event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      await _repository.updateRecurringRule(event.ruleId, event.data);
      emit(RecurringRuleSuccess('반복 규칙이 수정되었습니다'));
      
      // 목록 새로고침
      final rules = await _repository.getRecurringRules();
      emit(RecurringRulesLoaded(rules));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 삭제
  Future<void> _onDeleteRecurringRule(
    DeleteRecurringRule event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      await _repository.deleteRecurringRule(event.ruleId);
      emit(RecurringRuleSuccess('반복 규칙이 삭제되었습니다'));
      
      // 목록 새로고침
      final rules = await _repository.getRecurringRules();
      emit(RecurringRulesLoaded(rules));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 처리
  Future<void> _onProcessRecurringRules(
    ProcessRecurringRules event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      final result = await _repository.processRecurringRules();
      emit(RecurringRuleSuccess('반복 규칙 처리가 완료되었습니다'));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙에서 거래 생성
  Future<void> _onGenerateTransactionFromRule(
    GenerateTransactionFromRule event,
    Emitter<RecurringRuleState> emit,
  ) async {
    emit(RecurringRuleLoading());
    
    try {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await _repository.generateTransactionFromRule(
        ruleId: event.ruleId,
        date: date,
      );
      emit(RecurringRuleSuccess('거래가 생성되었습니다'));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }

  /// 반복 규칙 새로고침
  Future<void> _onRefreshRecurringRules(
    RefreshRecurringRules event,
    Emitter<RecurringRuleState> emit,
  ) async {
    try {
      final rules = await _repository.getRecurringRules(
        isActive: event.isActive,
        groupId: event.groupId,
      );
      emit(RecurringRulesLoaded(rules));
    } catch (e) {
      emit(RecurringRuleError(e.toString()));
    }
  }
}


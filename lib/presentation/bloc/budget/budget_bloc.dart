import 'package:flutter_bloc/flutter_bloc.dart';
import 'budget_event.dart';
import 'budget_state.dart';
import '../../../data/repositories/budget_repository.dart';

/// 예산 BLoC
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _repository;

  BudgetBloc({required BudgetRepository repository})
      : _repository = repository,
        super(BudgetInitial()) {
    
    on<LoadBudgets>(_onLoadBudgets);
    on<LoadBudget>(_onLoadBudget);
    on<CreateOrUpdateBudget>(_onCreateOrUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
    on<LoadBudgetStatus>(_onLoadBudgetStatus);
    on<RefreshBudgets>(_onRefreshBudgets);
  }

  /// 예산 목록 조회
  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    
    try {
      final budgets = await _repository.getBudgets(
        ownerType: event.ownerType,
        status: event.status,
      );
      emit(BudgetsLoaded(budgets));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  /// 예산 조회
  Future<void> _onLoadBudget(
    LoadBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    
    try {
      final budget = await _repository.getBudget(event.budgetId);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  /// 예산 생성/수정
  Future<void> _onCreateOrUpdateBudget(
    CreateOrUpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    
    try {
      await _repository.createOrUpdateBudget(event.data);
      emit(BudgetSuccess('예산이 저장되었습니다'));
      
      // 목록 새로고침
      final ownerType = event.data['owner_type'] as String? ?? 'USER';
      final budgets = await _repository.getBudgets(ownerType: ownerType);
      emit(BudgetsLoaded(budgets));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  /// 예산 삭제
  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    
    try {
      await _repository.deleteBudget(event.budgetId);
      emit(BudgetSuccess('예산이 삭제되었습니다'));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  /// 예산 현황 조회
  Future<void> _onLoadBudgetStatus(
    LoadBudgetStatus event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    
    try {
      final status = await _repository.getBudgetStatus(
        ownerType: event.ownerType,
        period: event.period,
      );
      emit(BudgetStatusLoaded(status));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  /// 예산 새로고침
  Future<void> _onRefreshBudgets(
    RefreshBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final budgets = await _repository.getBudgets(ownerType: event.ownerType);
      emit(BudgetsLoaded(budgets));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}


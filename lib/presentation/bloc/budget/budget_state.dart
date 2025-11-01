import 'package:equatable/equatable.dart';

/// 예산 관련 상태
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class BudgetInitial extends BudgetState {}

/// 로딩 중
class BudgetLoading extends BudgetState {}

/// 예산 목록 로드됨
class BudgetsLoaded extends BudgetState {
  final List<Map<String, dynamic>> budgets;

  const BudgetsLoaded(this.budgets);

  @override
  List<Object?> get props => [budgets];
}

/// 예산 상세 로드됨
class BudgetLoaded extends BudgetState {
  final Map<String, dynamic> budget;

  const BudgetLoaded(this.budget);

  @override
  List<Object?> get props => [budget];
}

/// 예산 현황 로드됨
class BudgetStatusLoaded extends BudgetState {
  final Map<String, dynamic> status;

  const BudgetStatusLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

/// 성공 상태
class BudgetSuccess extends BudgetState {
  final String message;

  const BudgetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}


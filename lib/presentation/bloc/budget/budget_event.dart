import 'package:equatable/equatable.dart';

/// 예산 관련 이벤트
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// 예산 목록 조회
class LoadBudgets extends BudgetEvent {
  final String ownerType; // USER or GROUP
  final String? status;

  const LoadBudgets({
    required this.ownerType,
    this.status,
  });

  @override
  List<Object?> get props => [ownerType, status];
}

/// 예산 조회
class LoadBudget extends BudgetEvent {
  final String budgetId;
  final String ownerType;

  const LoadBudget({
    required this.budgetId,
    required this.ownerType,
  });

  @override
  List<Object?> get props => [budgetId, ownerType];
}

/// 예산 생성/수정
class CreateOrUpdateBudget extends BudgetEvent {
  final Map<String, dynamic> data;

  const CreateOrUpdateBudget(this.data);

  @override
  List<Object?> get props => [data];
}

/// 예산 삭제
class DeleteBudget extends BudgetEvent {
  final String budgetId;

  const DeleteBudget(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

/// 예산 현황 조회
class LoadBudgetStatus extends BudgetEvent {
  final String ownerType;
  final String period; // YYYY-MM

  const LoadBudgetStatus({
    required this.ownerType,
    required this.period,
  });

  @override
  List<Object?> get props => [ownerType, period];
}

/// 예산 새로고침
class RefreshBudgets extends BudgetEvent {
  final String ownerType;

  const RefreshBudgets({required this.ownerType});

  @override
  List<Object?> get props => [ownerType];
}


import 'package:equatable/equatable.dart';

/// 반복 규칙 관련 상태
abstract class RecurringRuleState extends Equatable {
  const RecurringRuleState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class RecurringRuleInitial extends RecurringRuleState {}

/// 로딩 중
class RecurringRuleLoading extends RecurringRuleState {}

/// 반복 규칙 목록 로드됨
class RecurringRulesLoaded extends RecurringRuleState {
  final List<Map<String, dynamic>> rules;

  const RecurringRulesLoaded(this.rules);

  @override
  List<Object?> get props => [rules];
}

/// 반복 규칙 상세 로드됨
class RecurringRuleLoaded extends RecurringRuleState {
  final Map<String, dynamic> rule;

  const RecurringRuleLoaded(this.rule);

  @override
  List<Object?> get props => [rule];
}

/// 성공 상태
class RecurringRuleSuccess extends RecurringRuleState {
  final String message;

  const RecurringRuleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class RecurringRuleError extends RecurringRuleState {
  final String message;

  const RecurringRuleError(this.message);

  @override
  List<Object?> get props => [message];
}


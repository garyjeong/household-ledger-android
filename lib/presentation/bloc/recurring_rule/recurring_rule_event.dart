import 'package:equatable/equatable.dart';

/// 반복 규칙 관련 이벤트
abstract class RecurringRuleEvent extends Equatable {
  const RecurringRuleEvent();

  @override
  List<Object?> get props => [];
}

/// 반복 규칙 목록 조회
class LoadRecurringRules extends RecurringRuleEvent {
  final bool? isActive;
  final int? groupId;

  const LoadRecurringRules({
    this.isActive,
    this.groupId,
  });

  @override
  List<Object?> get props => [isActive, groupId];
}

/// 반복 규칙 조회
class LoadRecurringRule extends RecurringRuleEvent {
  final String ruleId;

  const LoadRecurringRule(this.ruleId);

  @override
  List<Object?> get props => [ruleId];
}

/// 반복 규칙 생성
class CreateRecurringRule extends RecurringRuleEvent {
  final Map<String, dynamic> data;

  const CreateRecurringRule(this.data);

  @override
  List<Object?> get props => [data];
}

/// 반복 규칙 수정
class UpdateRecurringRule extends RecurringRuleEvent {
  final String ruleId;
  final Map<String, dynamic> data;

  const UpdateRecurringRule(this.ruleId, this.data);

  @override
  List<Object?> get props => [ruleId, data];
}

/// 반복 규칙 삭제
class DeleteRecurringRule extends RecurringRuleEvent {
  final String ruleId;

  const DeleteRecurringRule(this.ruleId);

  @override
  List<Object?> get props => [ruleId];
}

/// 반복 규칙 처리
class ProcessRecurringRules extends RecurringRuleEvent {
  const ProcessRecurringRules();
}

/// 반복 규칙에서 거래 생성
class GenerateTransactionFromRule extends RecurringRuleEvent {
  final String ruleId;

  const GenerateTransactionFromRule(this.ruleId);

  @override
  List<Object?> get props => [ruleId];
}

/// 반복 규칙 새로고침
class RefreshRecurringRules extends RecurringRuleEvent {
  final bool? isActive;
  final int? groupId;

  const RefreshRecurringRules({
    this.isActive,
    this.groupId,
  });

  @override
  List<Object?> get props => [isActive, groupId];
}


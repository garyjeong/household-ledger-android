import 'package:equatable/equatable.dart';

/// 잔액 관련 이벤트
abstract class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object?> get props => [];
}

/// 잔액 조회
class LoadBalance extends BalanceEvent {
  final int? groupId;
  final bool includeProjection;
  final int projectionMonths;
  final String? period; // YYYY-MM 형식

  const LoadBalance({
    this.groupId,
    this.includeProjection = false,
    this.projectionMonths = 3,
    this.period,
  });

  @override
  List<Object?> get props => [groupId, includeProjection, projectionMonths, period];
}

/// 잔액 새로고침
class RefreshBalance extends BalanceEvent {
  final int? groupId;
  final bool includeProjection;
  final int projectionMonths;
  final String? period;

  const RefreshBalance({
    this.groupId,
    this.includeProjection = false,
    this.projectionMonths = 3,
    this.period,
  });

  @override
  List<Object?> get props => [groupId, includeProjection, projectionMonths, period];
}


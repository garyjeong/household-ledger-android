import 'package:equatable/equatable.dart';

/// 통계 관련 이벤트
abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => [];
}

/// 통계 데이터 로드
class LoadStatistics extends StatisticsEvent {
  final String? period; // current-month, last-month, etc.
  final String? startDate;
  final String? endDate;
  final String? type;
  final int? groupId;

  const LoadStatistics({
    this.period,
    this.startDate,
    this.endDate,
    this.type,
    this.groupId,
  });

  @override
  List<Object?> get props => [period, startDate, endDate, type, groupId];
}

/// 통계 새로고침
class RefreshStatistics extends StatisticsEvent {
  const RefreshStatistics();
}


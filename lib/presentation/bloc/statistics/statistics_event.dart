import 'package:equatable/equatable.dart';

/// 통계 관련 이벤트
abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => [];
}

/// 통계 데이터 로드
class LoadStatistics extends StatisticsEvent {
  final String? startDate;
  final String? endDate;
  final int? groupId;

  const LoadStatistics({
    this.startDate,
    this.endDate,
    this.groupId,
  });

  @override
  List<Object?> get props => [startDate, endDate, groupId];
}

/// 통계 새로고침
class RefreshStatistics extends StatisticsEvent {
  const RefreshStatistics();
}


import 'package:equatable/equatable.dart';

/// 통계 관련 상태
abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class StatisticsInitial extends StatisticsState {}

/// 로딩 중
class StatisticsLoading extends StatisticsState {}

/// 통계 데이터 로드 성공
class StatisticsLoaded extends StatisticsState {
  final Map<String, dynamic> data;
  
  const StatisticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// 에러 상태
class StatisticsError extends StatisticsState {
  final String message;
  
  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}


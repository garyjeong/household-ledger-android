import 'package:flutter_bloc/flutter_bloc.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';
import '../../../data/repositories/statistics_repository.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsBloc({required StatisticsRepository repository})
      : _repository = repository,
        super(StatisticsInitial()) {
    
    on<LoadStatistics>(_onLoadStatistics);
    on<RefreshStatistics>(_onRefreshStatistics);
  }

  /// 통계 데이터 로드
  Future<void> _onLoadStatistics(
    LoadStatistics event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());
    
    try {
      final data = await _repository.getStatistics(
        startDate: event.startDate,
        endDate: event.endDate,
        groupId: event.groupId,
      );
      
      emit(StatisticsLoaded(data));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  /// 통계 새로고침
  Future<void> _onRefreshStatistics(
    RefreshStatistics event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());
    try {
      // 기본값: 현재 날짜 기준 1개월 전 ~ 현재 날짜
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 1, now.day);
      final endDate = now;
      
      final data = await _repository.getStatistics(
        startDate: startDate.toIso8601String().split('T')[0],
        endDate: endDate.toIso8601String().split('T')[0],
      );
      emit(StatisticsLoaded(data));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}


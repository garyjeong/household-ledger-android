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
        type: event.type,
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
    try {
      final data = await _repository.getStatistics();
      emit(StatisticsLoaded(data));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}


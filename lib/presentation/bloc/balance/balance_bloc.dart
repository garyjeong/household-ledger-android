import 'package:flutter_bloc/flutter_bloc.dart';
import 'balance_event.dart';
import 'balance_state.dart';
import '../../../data/repositories/balance_repository.dart';

/// 잔액 BLoC
class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final BalanceRepository _repository;

  BalanceBloc({required BalanceRepository repository})
      : _repository = repository,
        super(BalanceInitial()) {
    
    on<LoadBalance>(_onLoadBalance);
    on<RefreshBalance>(_onRefreshBalance);
  }

  /// 잔액 조회
  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<BalanceState> emit,
  ) async {
    emit(BalanceLoading());
    
    try {
      final balance = await _repository.getBalance(
        groupId: event.groupId,
        includeProjection: event.includeProjection,
        projectionMonths: event.projectionMonths,
        period: event.period,
      );
      emit(BalanceLoaded(balance));
    } catch (e) {
      emit(BalanceError(e.toString()));
    }
  }

  /// 잔액 새로고침
  Future<void> _onRefreshBalance(
    RefreshBalance event,
    Emitter<BalanceState> emit,
  ) async {
    try {
      final balance = await _repository.getBalance(
        groupId: event.groupId,
        includeProjection: event.includeProjection,
        projectionMonths: event.projectionMonths,
        period: event.period,
      );
      emit(BalanceLoaded(balance));
    } catch (e) {
      emit(BalanceError(e.toString()));
    }
  }
}


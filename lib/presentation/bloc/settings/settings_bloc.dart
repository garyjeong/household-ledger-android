import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../../../data/repositories/settings_repository.dart';

/// 설정 BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc({required SettingsRepository repository})
      : _repository = repository,
        super(SettingsInitial()) {
    
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
    on<ResetSettings>(_onResetSettings);
  }

  /// 설정 조회
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    try {
      final settings = await _repository.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// 설정 업데이트
  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    try {
      final settings = await _repository.updateSettings(event.settings);
      emit(SettingsLoaded(settings));
      emit(SettingsSuccess('설정이 저장되었습니다'));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// 설정 초기화
  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    try {
      final settings = await _repository.resetSettings();
      emit(SettingsLoaded(settings));
      emit(SettingsSuccess('설정이 초기화되었습니다'));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}


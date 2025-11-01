import 'package:equatable/equatable.dart';

/// 설정 관련 상태
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class SettingsInitial extends SettingsState {}

/// 로딩 중
class SettingsLoading extends SettingsState {}

/// 설정 로드됨
class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// 성공 상태
class SettingsSuccess extends SettingsState {
  final String message;

  const SettingsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}


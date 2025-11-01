import 'package:equatable/equatable.dart';

/// 설정 관련 이벤트
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// 설정 조회
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// 설정 업데이트
class UpdateSettings extends SettingsEvent {
  final Map<String, dynamic> settings;

  const UpdateSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// 설정 초기화
class ResetSettings extends SettingsEvent {
  const ResetSettings();
}


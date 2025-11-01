import '../datasources/remote/settings_api.dart';

/// 설정 Repository
class SettingsRepository {
  final SettingsApi _api;

  SettingsRepository(this._api);

  /// 설정 조회
  Future<Map<String, dynamic>> getSettings() async {
    final response = await _api.getSettings();

    if (response is Map<String, dynamic>) {
      if (response.containsKey('success') && response['success'] == true) {
        return response['settings'] as Map<String, dynamic>? ?? response;
      }
      if (response.containsKey('settings')) {
        return response['settings'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }

    return response;
  }

  /// 설정 수정
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    final response = await _api.updateSettings(data);

    if (response is Map<String, dynamic>) {
      if (response.containsKey('success') && response['success'] == true) {
        return response['settings'] as Map<String, dynamic>? ?? response;
      }
      if (response.containsKey('settings')) {
        return response['settings'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }

    return response;
  }

  /// 설정 초기화
  Future<Map<String, dynamic>> resetSettings() async {
    final response = await _api.resetSettings();
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('success') && response['success'] == true) {
        return response['settings'] as Map<String, dynamic>? ?? response;
      }
      if (response.containsKey('settings')) {
        return response['settings'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }
}


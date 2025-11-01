import 'package:dio/dio.dart';

/// 설정 API 클라이언트
class SettingsApi {
  final Dio _dio;

  SettingsApi(this._dio);

  /// 설정 조회
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _dio.get('/settings');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 설정 수정
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/settings', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 설정 초기화
  Future<void> resetSettings() async {
    try {
      await _dio.delete('/settings');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 에러 처리
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['detail'] != null) {
        return data['detail'] as String;
      }
      return '요청 처리 중 오류가 발생했습니다';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return '서버 연결 시간이 초과되었습니다';
    } else if (error.type == DioExceptionType.connectionError) {
      return '서버에 연결할 수 없습니다';
    }
    return '알 수 없는 오류가 발생했습니다';
  }
}


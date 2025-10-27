import 'package:dio/dio.dart';

/// 통계 API 클라이언트
class StatisticsApi {
  final Dio _dio;

  StatisticsApi(this._dio);

  /// 통계 데이터 조회
  Future<Map<String, dynamic>> getStatistics({
    String? period, // current-month, last-month, etc.
    String? startDate,
    String? endDate,
    String? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (groupId != null) queryParams['groupId'] = groupId;

      final response = await _dio.get('/statistics', queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 월별 통계
  Future<Map<String, dynamic>> getMonthlyStats({
    required String period, // YYYY-MM
  }) async {
    try {
      final response = await _dio.get(
        '/dashboard/monthly-stats',
        queryParameters: {'period': period},
      );
      return response.data as Map<String, dynamic>;
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


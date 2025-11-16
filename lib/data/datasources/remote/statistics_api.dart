import 'package:dio/dio.dart';

/// 통계 API 클라이언트
class StatisticsApi {
  final Dio _dio;

  StatisticsApi(this._dio);

  /// 통계 데이터 조회
  Future<Map<String, dynamic>> getStatistics({
    String? startDate,
    String? endDate,
    int? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (groupId != null) queryParams['group_id'] = groupId;

      final response = await _dio.get('/statistics', queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 월별 통계
  Future<Map<String, dynamic>> getMonthlyStats({
    String? startDate,
    String? endDate,
    int? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (groupId != null) queryParams['group_id'] = groupId;

      final response = await _dio.get(
        '/dashboard/monthly-stats',
        queryParameters: queryParams,
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


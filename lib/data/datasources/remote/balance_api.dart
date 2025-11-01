import 'package:dio/dio.dart';

/// 잔액 API 클라이언트
class BalanceApi {
  final Dio _dio;

  BalanceApi(this._dio);

  /// 잔액 조회
  Future<Map<String, dynamic>> getBalance({
    String? period, // YYYY-MM
    bool? includeProjection,
    int? projectionMonths,
    String? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;
      if (includeProjection != null) queryParams['include_projection'] = includeProjection;
      if (projectionMonths != null) queryParams['projection_months'] = projectionMonths;
      if (groupId != null) queryParams['group_id'] = groupId;

      final response = await _dio.get('/balance', queryParameters: queryParams);
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


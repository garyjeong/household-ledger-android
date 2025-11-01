import 'package:dio/dio.dart';

/// 예산 API 클라이언트
class BudgetApi {
  final Dio _dio;

  BudgetApi(this._dio);

  /// 예산 목록 조회
  Future<Map<String, dynamic>> getBudgets({
    required String ownerType, // USER or GROUP
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'owner_type': ownerType,
      };
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get('/budgets', queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 예산 생성/수정
  Future<Map<String, dynamic>> createOrUpdateBudget(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/budgets', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 예산 현황 조회
  Future<Map<String, dynamic>> getBudgetStatus({
    required String ownerType,
    required String period, // YYYY-MM
  }) async {
    try {
      final response = await _dio.get(
        '/budgets/status',
        queryParameters: {
          'owner_type': ownerType,
          'period': period,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 예산 조회
  Future<Map<String, dynamic>> getBudget(String id) async {
    try {
      final response = await _dio.get('/budgets/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 예산 수정
  Future<Map<String, dynamic>> updateBudget(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/budgets/$id', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 예산 삭제
  Future<void> deleteBudget(String id) async {
    try {
      await _dio.delete('/budgets/$id');
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


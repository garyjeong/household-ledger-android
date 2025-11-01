import 'package:dio/dio.dart';

/// 반복 거래 규칙 API 클라이언트
class RecurringRuleApi {
  final Dio _dio;

  RecurringRuleApi(this._dio);

  /// 반복 거래 규칙 목록 조회
  Future<Map<String, dynamic>> getRecurringRules({
    bool? isActive,
    String? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isActive != null) queryParams['is_active'] = isActive;
      if (groupId != null) queryParams['group_id'] = groupId;

      final response = await _dio.get('/recurring-rules', queryParameters: queryParams);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 반복 거래 규칙 생성
  Future<Map<String, dynamic>> createRecurringRule(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/recurring-rules', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 반복 거래 규칙 조회
  Future<Map<String, dynamic>> getRecurringRule(String id) async {
    try {
      final response = await _dio.get('/recurring-rules/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 반복 거래 규칙 수정
  Future<Map<String, dynamic>> updateRecurringRule(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/recurring-rules/$id', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 반복 거래 규칙 삭제
  Future<void> deleteRecurringRule(String id) async {
    try {
      await _dio.delete('/recurring-rules/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 반복 거래 규칙 일괄 처리
  Future<Map<String, dynamic>> processRecurringRules({
    String? targetDate,
    String? startDate,
    String? endDate,
    String? ruleId,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (targetDate != null) data['target_date'] = targetDate;
      if (startDate != null) data['start_date'] = startDate;
      if (endDate != null) data['end_date'] = endDate;
      if (ruleId != null) data['rule_id'] = ruleId;

      final response = await _dio.post('/recurring-rules/process', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 특정 규칙에서 거래 생성
  Future<Map<String, dynamic>> generateTransactionFromRule({
    required String ruleId,
    required String date,
  }) async {
    try {
      final response = await _dio.post(
        '/recurring-rules/$ruleId/generate',
        data: {'date': date},
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


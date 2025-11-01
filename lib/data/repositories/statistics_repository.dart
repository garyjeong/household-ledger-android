import '../datasources/remote/statistics_api.dart';

/// 통계 Repository
class StatisticsRepository {
  final StatisticsApi _api;

  StatisticsRepository(this._api);

  /// 통계 데이터 조회
  Future<Map<String, dynamic>> getStatistics({
    String? period, // current-month, last-month, etc.
    String? startDate,
    String? endDate,
    String? type,
    int? groupId,
  }) async {
    final response = await _api.getStatistics(
      period: period,
      startDate: startDate,
      endDate: endDate,
      groupId: groupId,
    );

    // FastAPI 응답 형식 확인 및 변환
    if (response is Map<String, dynamic>) {
      // 응답이 이미 올바른 형식인 경우
      if (response.containsKey('summary') || response.containsKey('category_statistics')) {
        return response;
      }
      
      // 응답이 data 키 안에 있는 경우
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      
      // success 키가 있는 경우
      if (response.containsKey('success') && response['success'] == true) {
        return response['data'] as Map<String, dynamic>? ?? response;
      }
    }

    return response;
  }
}


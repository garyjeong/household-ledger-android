import '../datasources/remote/statistics_api.dart';

/// 통계 Repository
class StatisticsRepository {
  final StatisticsApi _api;

  StatisticsRepository(this._api);

  /// 통계 데이터 조회
  Future<Map<String, dynamic>> getStatistics({
    String? startDate,
    String? endDate,
    String? type,
  }) async {
    final response = await _api.getStatistics(
      startDate: startDate,
      endDate: endDate,
      type: type,
    );

    return response;
  }
}


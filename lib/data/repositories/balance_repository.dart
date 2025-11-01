import '../datasources/remote/balance_api.dart';

/// 잔액 Repository
class BalanceRepository {
  final BalanceApi _api;

  BalanceRepository(this._api);

  /// 잔액 조회
  Future<Map<String, dynamic>> getBalance({
    String? period,
    bool? includeProjection,
    int? projectionMonths,
    int? groupId,
  }) async {
    final response = await _api.getBalance(
      period: period,
      includeProjection: includeProjection,
      projectionMonths: projectionMonths,
      groupId: groupId?.toString(), // int?를 String?으로 변환
    );

    // FastAPI 응답 형식 확인
    if (response is Map<String, dynamic>) {
      if (response.containsKey('success') && response['success'] == true) {
        return response['data'] as Map<String, dynamic>? ?? response;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }

    return response;
  }
}


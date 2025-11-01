import '../datasources/remote/budget_api.dart';

/// 예산 Repository
class BudgetRepository {
  final BudgetApi _api;

  BudgetRepository(this._api);

  /// 예산 목록 조회
  Future<List<Map<String, dynamic>>> getBudgets({
    required String ownerType,
    String? status,
  }) async {
    final response = await _api.getBudgets(
      ownerType: ownerType,
      status: status,
    );

    if (response is Map<String, dynamic>) {
      if (response.containsKey('budgets') && response['budgets'] is List) {
        return List<Map<String, dynamic>>.from(response['budgets']);
      }
      if (response.containsKey('data') && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      if (response.containsKey('items') && response['items'] is List) {
        return List<Map<String, dynamic>>.from(response['items']);
      }
    }

    return [];
  }

  /// 예산 생성/수정
  Future<Map<String, dynamic>> createOrUpdateBudget(Map<String, dynamic> data) async {
    final response = await _api.createOrUpdateBudget(data);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('budget')) {
        return response['budget'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 예산 현황 조회
  Future<Map<String, dynamic>> getBudgetStatus({
    required String ownerType,
    required String period,
  }) async {
    final response = await _api.getBudgetStatus(
      ownerType: ownerType,
      period: period,
    );

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

  /// 예산 조회
  Future<Map<String, dynamic>> getBudget(String id) async {
    final response = await _api.getBudget(id);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('budget')) {
        return response['budget'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 예산 수정
  Future<Map<String, dynamic>> updateBudget(String id, Map<String, dynamic> data) async {
    final response = await _api.updateBudget(id, data);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('budget')) {
        return response['budget'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 예산 삭제
  Future<void> deleteBudget(String id) async {
    await _api.deleteBudget(id);
  }
}


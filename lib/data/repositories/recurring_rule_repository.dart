import '../datasources/remote/recurring_rule_api.dart';

/// 반복 거래 규칙 Repository
class RecurringRuleRepository {
  final RecurringRuleApi _api;

  RecurringRuleRepository(this._api);

  /// 반복 거래 규칙 목록 조회
  Future<List<Map<String, dynamic>>> getRecurringRules({
    bool? isActive,
    int? groupId,
  }) async {
    final response = await _api.getRecurringRules(
      isActive: isActive,
      groupId: groupId?.toString(),
    );

    if (response is Map<String, dynamic>) {
      if (response.containsKey('rules') && response['rules'] is List) {
        return List<Map<String, dynamic>>.from(response['rules']);
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

  /// 반복 거래 규칙 생성
  Future<Map<String, dynamic>> createRecurringRule(Map<String, dynamic> data) async {
    final response = await _api.createRecurringRule(data);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('rule')) {
        return response['rule'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 반복 거래 규칙 조회
  Future<Map<String, dynamic>> getRecurringRule(String id) async {
    final response = await _api.getRecurringRule(id);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('rule')) {
        return response['rule'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 반복 거래 규칙 수정
  Future<Map<String, dynamic>> updateRecurringRule(String id, Map<String, dynamic> data) async {
    final response = await _api.updateRecurringRule(id, data);
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('rule')) {
        return response['rule'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }

  /// 반복 거래 규칙 삭제
  Future<void> deleteRecurringRule(String id) async {
    await _api.deleteRecurringRule(id);
  }

  /// 반복 거래 규칙 일괄 처리
  Future<Map<String, dynamic>> processRecurringRules({
    String? targetDate,
    String? startDate,
    String? endDate,
    String? ruleId,
  }) async {
    final response = await _api.processRecurringRules(
      targetDate: targetDate,
      startDate: startDate,
      endDate: endDate,
      ruleId: ruleId,
    );

    return response;
  }

  /// 특정 규칙에서 거래 생성
  Future<Map<String, dynamic>> generateTransactionFromRule({
    required String ruleId,
    required String date,
  }) async {
    final response = await _api.generateTransactionFromRule(
      ruleId: ruleId,
      date: date,
    );
    
    if (response is Map<String, dynamic>) {
      if (response.containsKey('transaction')) {
        return response['transaction'] as Map<String, dynamic>;
      }
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
    }
    
    return response;
  }
}


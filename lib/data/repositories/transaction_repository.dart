import '../../domain/entities/transaction.dart';
import '../datasources/remote/transaction_api.dart';

/// 거래 Repository
class TransactionRepository {
  final TransactionApi _api;

  TransactionRepository(this._api);

  /// 거래 목록 조회 (페이지네이션 지원)
  Future<Map<String, dynamic>> getTransactions({
    String? type,
    String? startDate,
    String? endDate,
    String? categoryId,
    String? search,
    int? offset,
    int? limit,
  }) async {
    final response = await _api.getTransactions(
      type: type,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      search: search,
      offset: offset,
      limit: limit,
    );

    // FastAPI 응답 형식: PaginatedResponse { "items": [...], "total": ..., "limit": ..., "offset": ... }
    final List<Transaction> transactions = [];
    
    if (response['items'] is List) {
      transactions.addAll(
        (response['items'] as List)
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList(),
      );
    } else if (response['transactions'] is List) {
      // Fallback: transactions 키도 확인
      transactions.addAll(
        (response['transactions'] as List)
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList(),
      );
    }

    final total = response['total'] as int? ?? transactions.length;
    final limitValue = response['limit'] as int? ?? limit ?? 50;
    final currentOffset = response['offset'] as int? ?? offset ?? 0;
    final currentPage = (currentOffset / limitValue).floor() + 1;
    final hasMore = (currentOffset + transactions.length) < total;

    return {
      'transactions': transactions,
      'total': total,
      'page': currentPage,
      'offset': currentOffset,
      'limit': limitValue,
      'hasMore': hasMore,
    };
  }
  
  /// 거래 목록 조회 (하위 호환성을 위한 메서드)
  Future<List<Transaction>> getTransactionsList({
    String? type,
    String? startDate,
    String? endDate,
    String? categoryId,
    String? search,
    int? offset,
    int? limit,
  }) async {
    final result = await getTransactions(
      type: type,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      search: search,
      offset: offset,
      limit: limit,
    );
    return result['transactions'] as List<Transaction>;
  }

  /// 거래 생성
  Future<Transaction> createTransaction(Map<String, dynamic> data) async {
    final response = await _api.createTransaction(data);
    // FastAPI 응답 형식: { "success": true, "data": {...} } 또는 직접 transaction 객체
    if (response is Map<String, dynamic>) {
      if (response['transaction'] != null) {
        return Transaction.fromJson(response['transaction'] as Map<String, dynamic>);
      }
      if (response['data'] != null) {
        return Transaction.fromJson(response['data'] as Map<String, dynamic>);
      }
      // 직접 transaction 객체인 경우
      return Transaction.fromJson(response);
    }
    throw Exception('Invalid response format');
  }

  /// 거래 수정
  Future<Transaction> updateTransaction(String id, Map<String, dynamic> data) async {
    final response = await _api.updateTransaction(id, data);
    // FastAPI 응답 형식: { "success": true, "data": {...} } 또는 직접 transaction 객체
    if (response is Map<String, dynamic>) {
      if (response['transaction'] != null) {
        return Transaction.fromJson(response['transaction'] as Map<String, dynamic>);
      }
      if (response['data'] != null) {
        return Transaction.fromJson(response['data'] as Map<String, dynamic>);
      }
      // 직접 transaction 객체인 경우
      return Transaction.fromJson(response);
    }
    throw Exception('Invalid response format');
  }

  /// 거래 삭제
  Future<void> deleteTransaction(String id) async {
    await _api.deleteTransaction(id);
  }

  /// 빠른 거래 추가 (Quick Add - 카테고리 자동 생성)
  Future<Transaction> quickAddTransaction(Map<String, dynamic> data) async {
    final response = await _api.quickAdd(data);
    // Quick Add API 응답 형식: { "success": true, "transaction": {...} }
    if (response is Map<String, dynamic>) {
      if (response['transaction'] != null) {
        return Transaction.fromJson(response['transaction'] as Map<String, dynamic>);
      }
      if (response['data'] != null) {
        return Transaction.fromJson(response['data'] as Map<String, dynamic>);
      }
      // 직접 transaction 객체인 경우
      return Transaction.fromJson(response);
    }
    throw Exception('Invalid response format');
  }
}


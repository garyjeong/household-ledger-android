import '../../domain/entities/transaction.dart';
import '../datasources/remote/transaction_api.dart';

/// 거래 Repository
class TransactionRepository {
  final TransactionApi _api;

  TransactionRepository(this._api);

  /// 거래 목록 조회
  Future<List<Transaction>> getTransactions({
    String? type,
    String? startDate,
    String? endDate,
    String? categoryId,
    String? search,
    int? page,
    int? limit,
  }) async {
    final response = await _api.getTransactions(
      type: type,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      search: search,
      page: page,
      limit: limit,
    );

    if (response['transactions'] is List) {
      return (response['transactions'] as List)
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// 거래 생성
  Future<Transaction> createTransaction(Map<String, dynamic> data) async {
    final response = await _api.createTransaction(data);
    return Transaction.fromJson(response);
  }

  /// 거래 수정
  Future<Transaction> updateTransaction(String id, Map<String, dynamic> data) async {
    final response = await _api.updateTransaction(id, data);
    return Transaction.fromJson(response);
  }

  /// 거래 삭제
  Future<void> deleteTransaction(String id) async {
    await _api.deleteTransaction(id);
  }
}


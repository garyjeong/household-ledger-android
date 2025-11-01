import 'package:equatable/equatable.dart';
import '../../../../domain/entities/transaction.dart';

/// 거래 관련 상태
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class TransactionInitial extends TransactionState {}

/// 로딩 중
class TransactionLoading extends TransactionState {}

/// 거래 목록 로드 성공
class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;
  final int total; // 전체 거래 수
  final int offset; // 현재 오프셋
  final int limit; // 페이지 크기
  final bool hasMore; // 더 불러올 수 있는지
  
  const TransactionsLoaded({
    required this.transactions,
    required this.total,
    required this.offset,
    required this.limit,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [transactions, total, offset, limit, hasMore];
}

/// 거래 생성/수정/삭제 성공
class TransactionSuccess extends TransactionState {
  final String message;
  
  const TransactionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class TransactionError extends TransactionState {
  final String message;
  
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}


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
  
  const TransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
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


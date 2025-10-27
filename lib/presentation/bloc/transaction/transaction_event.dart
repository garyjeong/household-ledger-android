import 'package:equatable/equatable.dart';

/// 거래 관련 이벤트
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// 거래 목록 조회
class LoadTransactions extends TransactionEvent {
  final String? type;
  final String? startDate;
  final String? endDate;
  
  const LoadTransactions({
    this.type,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [type, startDate, endDate];
}

/// 거래 생성
class CreateTransaction extends TransactionEvent {
  final Map<String, dynamic> data;
  
  const CreateTransaction(this.data);

  @override
  List<Object?> get props => [data];
}

/// 거래 수정
class UpdateTransaction extends TransactionEvent {
  final String id;
  final Map<String, dynamic> data;
  
  const UpdateTransaction(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

/// 거래 삭제
class DeleteTransaction extends TransactionEvent {
  final String id;
  
  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}

/// 거래 새로고침
class RefreshTransactions extends TransactionEvent {
  const RefreshTransactions();
}


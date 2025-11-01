import 'package:equatable/equatable.dart';

/// 잔액 관련 상태
abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class BalanceInitial extends BalanceState {}

/// 로딩 중
class BalanceLoading extends BalanceState {}

/// 잔액 로드됨
class BalanceLoaded extends BalanceState {
  final Map<String, dynamic> balance;

  const BalanceLoaded(this.balance);

  @override
  List<Object?> get props => [balance];
}

/// 에러 상태
class BalanceError extends BalanceState {
  final String message;

  const BalanceError(this.message);

  @override
  List<Object?> get props => [message];
}


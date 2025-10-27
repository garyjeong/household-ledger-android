import 'package:equatable/equatable.dart';

/// 인증 상태 (BLoC Pattern)
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class AuthInitial extends AuthState {}

/// 로딩 중
class AuthLoading extends AuthState {}

/// 인증 성공
class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// 인증 실패
class AuthUnauthenticated extends AuthState {}

/// 에러 상태
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}


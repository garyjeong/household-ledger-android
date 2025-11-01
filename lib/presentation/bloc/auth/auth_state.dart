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

/// 비밀번호 찾기 성공 상태
class AuthForgotPasswordSuccess extends AuthState {
  final String message;
  final String? token; // 개발 환경용 토큰 (프로덕션에서는 제거)

  const AuthForgotPasswordSuccess({
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [message, token];
}

/// 비밀번호 리셋 성공 상태
class AuthResetPasswordSuccess extends AuthState {
  final String message;

  const AuthResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}


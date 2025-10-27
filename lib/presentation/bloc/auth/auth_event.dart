import 'package:equatable/equatable.dart';

/// 인증 이벤트 (BLoC Pattern)
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// 로그인 이벤트
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// 로그아웃 이벤트
class LogoutRequested extends AuthEvent {}

/// 인증 상태 확인 이벤트
class AuthStatusChecked extends AuthEvent {}


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

/// 프로필 조회 이벤트
class ProfileRequested extends AuthEvent {}

/// 프로필 수정 이벤트
class ProfileUpdateRequested extends AuthEvent {
  final String? nickname;
  final String? email;

  const ProfileUpdateRequested({
    this.nickname,
    this.email,
  });

  @override
  List<Object?> get props => [nickname, email];
}

/// 비밀번호 변경 이벤트
class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// 회원가입 이벤트
class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String nickname;
  final String? inviteCode;

  const SignupRequested({
    required this.email,
    required this.password,
    required this.nickname,
    this.inviteCode,
  });

  @override
  List<Object?> get props => [email, password, nickname, inviteCode];
}

/// 비밀번호 찾기 이벤트
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// 비밀번호 리셋 이벤트
class ResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const ResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_ledger/data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// 인증 BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  /// 로그인 요청 처리
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      // 로그인 성공 후 프로필 조회
      final userData = await _authRepository.getProfile();
      emit(AuthAuthenticated(user: userData));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// 회원가입 요청 처리
  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.signup(
        email: event.email,
        password: event.password,
        nickname: event.nickname,
        inviteCode: event.inviteCode,
      );
      
      // 회원가입 성공 후 자동 로그인
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      
      // 로그인 성공 후 프로필 조회
      final userData = await _authRepository.getProfile();
      emit(AuthAuthenticated(user: userData));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// 로그아웃 요청 처리
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  /// 인증 상태 확인
  void _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    if (_authRepository.isLoggedIn) {
      try {
        final userData = await _authRepository.getProfile();
        emit(AuthAuthenticated(user: userData));
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// 프로필 조회
  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_authRepository.isLoggedIn) {
      try {
        final userData = await _authRepository.getProfile();
        emit(AuthAuthenticated(user: userData));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// 프로필 수정
  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final updatedUser = await _authRepository.updateProfile(
        nickname: event.nickname,
        email: event.email,
      );
      emit(AuthAuthenticated(user: updatedUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// 비밀번호 변경
  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      // 비밀번호 변경 후 프로필 다시 조회
      final userData = await _authRepository.getProfile();
      emit(AuthAuthenticated(user: userData));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// 비밀번호 찾기
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final response = await _authRepository.forgotPassword(event.email);
      
      // 개발 환경에서는 토큰이 포함될 수 있음
      emit(AuthForgotPasswordSuccess(
        message: response['message'] as String? ?? '비밀번호 재설정 링크가 이메일로 전송되었습니다',
        token: response['token'] as String?,
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// 비밀번호 리셋
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.resetPassword(
        token: event.token,
        newPassword: event.newPassword,
      );
      emit(AuthResetPasswordSuccess(
        message: '비밀번호가 성공적으로 변경되었습니다',
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}


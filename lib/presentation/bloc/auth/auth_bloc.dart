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
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
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

      emit(AuthAuthenticated(user: const {}));
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
  ) {
    if (_authRepository.isLoggedIn) {
      emit(AuthAuthenticated(user: {}));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}


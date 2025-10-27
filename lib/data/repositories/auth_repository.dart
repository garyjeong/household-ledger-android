import '../datasources/remote/auth_api.dart';
import '../datasources/local/local_storage.dart';

/// 인증 Repository
class AuthRepository {
  final AuthApi _authApi;
  final LocalStorage _localStorage;

  AuthRepository({
    required AuthApi authApi,
    required LocalStorage localStorage,
  })  : _authApi = authApi,
        _localStorage = localStorage;

  /// 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.login(
        email: email,
        password: password,
      );

      // 토큰 저장
      if (response.containsKey('access_token') &&
          response.containsKey('refresh_token')) {
        await _localStorage.saveAccessToken(response['access_token']);
        await _localStorage.saveRefreshToken(response['refresh_token']);
        await _localStorage.saveUserEmail(email);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 회원가입
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String nickname,
    String? inviteCode,
  }) async {
    return await _authApi.signup(
      email: email,
      password: password,
      nickname: nickname,
      inviteCode: inviteCode,
    );
  }

  /// 로그아웃
  Future<void> logout() async {
    await _localStorage.clearAll();
  }

  /// 현재 로그인 상태 확인
  bool get isLoggedIn {
    final token = _localStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 저장된 토큰 조회
  String? getAccessToken() => _localStorage.getAccessToken();
  String? getRefreshToken() => _localStorage.getRefreshToken();
}


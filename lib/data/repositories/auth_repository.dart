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

  /// 프로필 조회
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _authApi.getProfile();
      
      if (response is Map<String, dynamic>) {
        if (response.containsKey('success') && response['success'] == true) {
          return response['user'] as Map<String, dynamic>? ?? response;
        }
        if (response.containsKey('user')) {
          return response['user'] as Map<String, dynamic>;
        }
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 프로필 수정
  Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    String? email,
  }) async {
    try {
      final response = await _authApi.updateProfile(
        nickname: nickname,
        email: email,
      );
      
      if (response is Map<String, dynamic>) {
        if (response.containsKey('success') && response['success'] == true) {
          return response['user'] as Map<String, dynamic>? ?? response;
        }
        if (response.containsKey('user')) {
          return response['user'] as Map<String, dynamic>;
        }
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      // 서버 로그아웃 실패해도 클라이언트 토큰 삭제
    } finally {
      await _localStorage.clearAll();
    }
  }

  /// 비밀번호 변경
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authApi.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 현재 로그인 상태 확인
  bool get isLoggedIn {
    final token = _localStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 저장된 토큰 조회
  String? getAccessToken() => _localStorage.getAccessToken();
  String? getRefreshToken() => _localStorage.getRefreshToken();
  
  /// LocalStorage 인스턴스 접근 (인터셉터용)
  LocalStorage get localStorage => _localStorage;
  
  /// 토큰 갱신
  Future<Map<String, String>> refreshToken(String refreshToken) async {
    try {
      final response = await _authApi.refreshToken(refreshToken: refreshToken);
      
      // 새 토큰 저장
      if (response.containsKey('access_token')) {
        await _localStorage.saveAccessToken(response['access_token']);
        if (response.containsKey('refresh_token')) {
          await _localStorage.saveRefreshToken(response['refresh_token']);
        }
      }
      
      return {
        'access_token': response['access_token'] as String,
        'refresh_token': response['refresh_token'] as String? ?? refreshToken,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 찾기
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _authApi.forgotPassword(email: email);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 리셋
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _authApi.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }
}


import 'package:shared_preferences/shared_preferences.dart';

/// 로컬 저장소 관리
class LocalStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';

  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  /// Access Token 조회
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  /// Refresh Token 조회
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  /// 이메일 저장
  Future<void> saveUserEmail(String email) async {
    await _prefs.setString(_userEmailKey, email);
  }

  /// 이메일 조회
  String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  /// 모든 토큰 삭제
  Future<void> clearAll() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userEmailKey);
  }
}


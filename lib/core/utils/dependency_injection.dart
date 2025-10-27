import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/datasources/remote/auth_api.dart';
import '../../data/providers/http_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

/// 의존성 주입 관리
class DependencyInjection {
  static late SharedPreferences _sharedPreferences;
  static late LocalStorage _localStorage;
  static late AuthApi _authApi;
  static late AuthRepository _authRepository;

  /// 초기화
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStorage = LocalStorage(_sharedPreferences);
    
    final dio = HttpClientFactory.createDio();
    _authApi = AuthApi(dio);
    _authRepository = AuthRepository(
      authApi: _authApi,
      localStorage: _localStorage,
    );
  }

  /// AuthRepository 인스턴스
  static AuthRepository get authRepository => _authRepository;

  /// AuthBloc 인스턴스 생성
  static AuthBloc createAuthBloc() {
    return AuthBloc(authRepository: _authRepository);
  }
}


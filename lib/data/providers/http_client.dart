import 'package:dio/dio.dart';
import '../../core/utils/dependency_injection.dart';
import '../../config/app_config.dart';

/// 인증 토큰 인터셉터
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 인증이 필요한 엔드포인트만 토큰 추가
    final publicPaths = [
      '/auth/login',
      '/auth/signup',
      '/auth/refresh',
    ];
    
    final isPublicPath = publicPaths.any((path) => options.path.contains(path));
    
    if (!isPublicPath) {
      final accessToken = DependencyInjection.authRepository.localStorage.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러 시 토큰 갱신 시도
    if (err.response?.statusCode == 401) {
      final refreshToken = DependencyInjection.authRepository.getRefreshToken();
      
      if (refreshToken != null) {
        try {
          // 토큰 갱신 시도
          final newTokens = await DependencyInjection.authRepository.refreshToken(refreshToken);
          
          // 새 토큰으로 원래 요청 재시도
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newTokens['access_token']}';
          
          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          // 토큰 갱신 실패 시 로그아웃 처리
          await DependencyInjection.authRepository.localStorage.clearAll();
          return handler.reject(err);
        }
      }
    }
    
    handler.next(err);
  }
}

/// HTTP 클라이언트 팩토리
class HttpClientFactory {
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 인증 토큰 인터셉터 (가장 먼저 추가)
    dio.interceptors.add(AuthInterceptor());

    // 로깅 interceptor (개발 모드)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}


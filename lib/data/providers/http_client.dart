import 'package:dio/dio.dart';

/// HTTP 클라이언트 팩토리
class HttpClientFactory {
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

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


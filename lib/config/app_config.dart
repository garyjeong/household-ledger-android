/// 앱 설정
class AppConfig {
  AppConfig._();
  
  static const String appName = '신혼부부 가계부';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.householdledger.household_ledger';
  
  // API Configuration
  static String get apiBaseUrl {
    // 환경변수에서 읽어오기 (--dart-define=API_BASE_URL=... 로 전달 가능)
    const String env = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');
    return env;
  }
  
  static String get apiVersion => '/api/v1';
  
  static String get baseUrl => '$apiBaseUrl$apiVersion';
  
  // Feature flags
  static const bool enableLogging = true;
  static const bool enableCrashlytics = false;
  static const bool enableAnalytics = false;
  
  // Build
  static const String buildEnvironment = String.fromEnvironment(
    'BUILD_ENVIRONMENT',
    defaultValue: 'development',
  );
  
  static bool get isProduction => buildEnvironment == 'production';
  static bool get isDevelopment => buildEnvironment == 'development';
}


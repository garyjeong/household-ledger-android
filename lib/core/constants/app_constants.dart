/// 앱 상수 정의
class AppConstants {
  AppConstants._();
  
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';
  static const String baseUrl = '$apiBaseUrl$apiVersion';
  
  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String transactionsEndpoint = '/transactions';
  static const String categoriesEndpoint = '/categories';
  static const String statisticsEndpoint = '/statistics';
  static const String groupsEndpoint = '/groups';
  
  // Spacing (8dp grid system)
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius (M3)
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  
  // Component specific
  static const double buttonRadius = radiusSM; // 8dp
  static const double cardRadius = radiusLG;    // 16dp
  static const double inputRadius = radiusMD;  // 12dp
  static const double fabRadius = radiusLG;    // 16dp
  static const double chipRadius = radiusXL;   // 24dp
  static const double sheetRadius = radiusXL;  // 24dp
  
  // Touch targets
  static const double minTouchTarget = 48.0;
  static const double minTouchMargin = spacingSM;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}


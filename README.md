# 💑 신혼부부 가계부 - Flutter App

Material Design 3 기반 Flutter 모바일 앱

## 🚀 시작하기

### 필수 요구사항
- Flutter 3.x
- Dart 3.x
- Android Studio / VS Code
- FastAPI 서버 실행 중 (localhost:8000)

### 설치 및 실행

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (Hive models)
flutter pub run build_runner build

# 3. 앱 실행
flutter run

# iOS 실행 (macOS)
flutter run -d ios

# Android 실행
flutter run -d android
```

## 📁 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── app.dart                     # MaterialApp 설정
├── config/
│   └── app_config.dart
├── core/
│   ├── theme/
│   ├── constants/
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## 🎨 Material Design 3

- 동적 컬러 (Material You)
- M3 타이포그래피
- 둥근 모서리
- Surface Tinting

## 🔗 API 연동

- Base URL: `http://localhost:8000`
- API Version: `/api/v1`

## 📚 문서

프로젝트 현황은 `SUMMARY.md`를 참고하세요.


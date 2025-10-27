# 🚀 Flutter 프로젝트 설정 가이드

## 1️⃣ Flutter 설치

### macOS
```bash
# Homebrew로 설치
brew install --cask flutter

# 또는 직접 다운로드
# https://docs.flutter.dev/get-started/install/macos
```

### 설치 확인
```bash
flutter doctor
# 필수 항목:
# - Flutter (latest stable channel)
# - Dart SDK
# - Android toolchain
# - Xcode (iOS 개발용)
```

## 2️⃣ 프로젝트 초기화

### 현재 상태
```
household-ledger-android/
└── household_ledger_app/    # ✅ 기본 구조 생성 완료
    ├── lib/
    ├── test/
    ├── assets/
    ├── pubspec.yaml         # ✅ 생성 완료
    └── README.md
```

### Flutter 프로젝트 완성하기

```bash
cd household_ledger_android/household_ledger_app

# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (Hive models 등)
flutter pub run build_runner build

# 3. 프로젝트 실행
flutter run
```

## 3️⃣ 필요한 파일들

### `.gitignore` 생성
```bash
cd household_ledger_app
# .gitignore는 Flutter 기본 생성
```

### 환경 변수 설정 (선택)
`lib/config/app_config.dart`에서 API URL 변경:
```dart
static String get apiBaseUrl {
  const String env = String.fromEnvironment(
    'API_BASE_URL', 
    defaultValue: 'http://localhost:8000'
  );
  return env;
}
```

## 4️⃣ 다음 단계

### 필요한 추가 작업:
1. ✅ 프로젝트 구조 생성 - 완료
2. ⏳ Flutter 설치 필요
3. ⏳ 로그인 화면 구현
4. ⏳ BLoC 패턴 적용
5. ⏳ 네트워크 레이어 구현

### Flutter 설치 후 할 일:
```bash
cd household_ledger_android/household_ledger_app

# 1. 의존성 설치
flutter pub get

# 2. Hive 초기화
flutter pub run build_runner build

# 3. 앱 실행
flutter run
```

## 5️⃣ 문제 해결

### Flutter 명령어가 없는 경우
```bash
# macOS
brew install --cask flutter

# PATH 확인
export PATH="$PATH:$HOME/flutter/bin"
```

### Android Studio 연동
1. Android Studio 설치
2. Flutter Plugin 설치
3. SDK 설정 확인

### 에뮬레이터 실행
```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

## 📚 참고 문서

- [Flutter 공식 문서](https://docs.flutter.dev)
- [Material Design 3](https://m3.material.io)
- [Flutter BLoC 패턴](https://bloclibrary.dev)
- [Hive 문서](https://docs.hivedb.dev)


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
├── main.dart                           # 앱 진입점
├── config/
│   └── app_config.dart                # 앱 설정
├── core/                               # 핵심 로직
│   ├── constants/
│   │   └── app_constants.dart
│   ├── router/
│   │   └── app_router.dart            # 네비게이션 라우팅
│   ├── theme/
│   │   └── app_theme.dart             # Material Design 3 테마
│   └── utils/
│       └── dependency_injection.dart   # DI 설정
├── data/                               # 데이터 계층
│   ├── datasources/
│   │   ├── local/
│   │   │   └── local_storage.dart     # SharedPreferences
│   │   └── remote/
│   │       ├── auth_api.dart          # 인증 API
│   │       ├── transaction_api.dart   # 거래 API
│   │       ├── category_api.dart      # 카테고리 API
│   │       └── statistics_api.dart    # 통계 API
│   ├── models/
│   │   └── user_model.dart
│   ├── providers/
│   │   └── http_client.dart           # Dio HTTP 클라이언트
│   └── repositories/
│       ├── auth_repository.dart
│       ├── transaction_repository.dart
│       ├── category_repository.dart
│       └── statistics_repository.dart
├── domain/                             # 도메인 계층
│   ├── entities/
│   │   ├── user.dart
│   │   └── transaction.dart
│   ├── repositories/
│   └── usecases/
└── presentation/                       # 프레젠테이션 계층
    ├── bloc/
    │   ├── auth/                      # 인증 BLoC
    │   ├── transaction/               # 거래 BLoC
    │   ├── category/                  # 카테고리 BLoC
    │   └── statistics/                # 통계 BLoC
    ├── pages/
    │   ├── login/                     # 로그인 화면
    │   ├── signup/                    # 회원가입 화면
    │   ├── dashboard/                 # 대시보드 화면
    │   ├── transactions/              # 거래 내역 화면
    │   ├── statistics/                # 통계 화면
    │   └── profile/                    # 프로필 화면
    └── widgets/
        └── common/
            ├── app_logo.dart
            ├── bottom_nav_bar.dart
            └── loading_button.dart
```

## 🎨 Material Design 3

- 동적 컬러 (Material You)
- M3 타이포그래피
- 둥근 모서리
- Surface Tinting

## 🔗 API 연동

- Base URL: `http://localhost:8000`
- API Version: `/api/v1`

## 🧪 앱 테스트 방법

### 1. 로컬 서버 실행 (필수)
```bash
# 서버 디렉토리로 이동
cd ../household-ledger-server

# 가상환경 활성화
source .venv/bin/activate

# 데이터베이스 실행 (별도 터미널)
cd docker/database
./start-db.sh

# FastAPI 서버 실행
cd ../../app
uvicorn main:app --reload
```

### 2. Flutter 앱 실행
```bash
# 현재 디렉토리 (household-ledger-android)

# 1. 의존성 설치
flutter pub get

# 2. 앱 실행 (Android)
flutter run -d android

# 3. 또는 iOS 실행
flutter run -d ios
```

### 3. 기능 테스트

#### 인증 기능
1. 회원가입: 이메일, 비밀번호, 닉네임 입력
2. 로그인: 생성한 계정으로 로그인
3. 대시보드 확인

#### 거래 관리 (현재 미구현)
- Floating Action Button 클릭
- 거래 입력 모달에서 정보 입력
- 저장 버튼 클릭 (TODO: 실제 서버 연동 필요)

#### 네비게이션
- 하단 네비게이션 바에서 탭 전환:
  - 홈 → 거래내역 → 통계 → 내정보

### 4. 현재 구현 상태

#### ✅ 완료된 기능
- 로그인/회원가입 UI
- 대시보드 화면
- 거래 내역 리스트
- 통계 화면 (차트)
- 프로필 화면
- BLoC 패턴 (4개)
- API 클라이언트

#### ⚠️ 아직 미완성
- **실제 API 연동**: BLoC이 UI와 연결되지 않음
- **거래 CRUD**: 모달은 구현되었지만 실제 저장 미구현
- **카테고리 선택**: 임시 데이터만 존재

### 5. 다음 단계

#### UI-BLoC 연동 필요
1. `dependency_injection.dart` 업데이트:
   - TransactionBloc, CategoryBloc, StatisticsBloc 추가

2. 각 페이지에서 BLoC 사용:
   ```dart
   BlocProvider(
     create: (context) => DependencyInjection.createTransactionBloc(),
     child: TransactionListPage(),
   )
   ```

3. 실제 API 호출 테스트

## 📚 문서

프로젝트 현황은 `SUMMARY.md`를 참고하세요.

## 🛠️ 기술 스택

- **언어**: Dart 3.x
- **프레임워크**: Flutter 3.x
- **상태 관리**: BLoC Pattern
- **네트워크**: Dio
- **스토리지**: SharedPreferences
- **차트**: fl_chart
- **폰트**: Google Fonts (Noto Sans)
- **디자인**: Material Design 3

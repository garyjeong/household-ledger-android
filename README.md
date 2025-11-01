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

# 2. 앱 실행
flutter run

# iOS 실행 (macOS)
flutter run -d ios

# Android 실행
flutter run -d android

# 환경변수와 함께 실행 (선택사항)
flutter run --dart-define=API_BASE_URL=http://your-server:8000
```

## 📁 프로젝트 구조

```
lib/
├── main.dart                           # 앱 진입점
├── config/
│   └── app_config.dart                # 앱 설정 (환경변수 지원)
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
│   │       ├── statistics_api.dart    # 통계 API
│   │       ├── group_api.dart         # 그룹 API
│   │       ├── balance_api.dart       # 잔액 API
│   │       ├── budget_api.dart        # 예산 API
│   │       ├── settings_api.dart     # 설정 API
│   │       └── recurring_rule_api.dart # 반복 규칙 API
│   ├── models/
│   │   └── user_model.dart
│   ├── providers/
│   │   └── http_client.dart           # Dio HTTP 클라이언트 (인증 인터셉터)
│   └── repositories/
│       ├── auth_repository.dart
│       ├── transaction_repository.dart
│       ├── category_repository.dart
│       ├── statistics_repository.dart
│       ├── group_repository.dart
│       ├── balance_repository.dart
│       ├── budget_repository.dart
│       ├── settings_repository.dart
│       └── recurring_rule_repository.dart
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
    │   ├── statistics/                # 통계 BLoC
    │   ├── group/                     # 그룹 BLoC
    │   └── settings/                    # 설정 BLoC
    ├── pages/
    │   ├── login/                     # 로그인 화면
    │   ├── signup/                    # 회원가입 화면
    │   ├── forgot_password/           # 비밀번호 찾기 화면
    │   ├── dashboard/                 # 대시보드 화면
    │   ├── transactions/              # 거래 내역 화면
    │   │   ├── transaction_list_page.dart
    │   │   ├── transaction_detail_page.dart
    │   │   └── quick_add_modal.dart
    │   ├── statistics/                # 통계 화면
    │   ├── profile/                   # 프로필 화면
    │   ├── categories/                # 카테고리 관리 화면
    │   └── groups/                    # 그룹 관리 화면
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

- Base URL: `http://localhost:8000` (기본값)
- API Version: `/api/v1`
- 환경변수 지원: `--dart-define=API_BASE_URL=...`

### 인증 인터셉터
- 자동 JWT 토큰 첨부
- 401 에러 시 자동 토큰 갱신
- 토큰 갱신 실패 시 자동 로그아웃

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
3. 프로필 수정: 닉네임, 이메일 변경
4. 비밀번호 변경
5. 로그아웃

#### 거래 관리
- 거래 목록 조회 (검색, 필터, 정렬, 무한 스크롤)
- 거래 상세 보기
- 거래 생성 (Quick Add Modal)
- 거래 수정
- 거래 삭제
- 페이지네이션 (오프셋 기반)

#### 카테고리 관리
- 카테고리 목록 조회 (지출/수입/이체 분류)
- 카테고리 생성/수정/삭제
- 색상 선택 (flutter_colorpicker)
- 예산 금액 설정

#### 그룹 관리
- 그룹 목록 조회
- 그룹 생성/수정/삭제
- 초대 코드 생성 및 복사
- 그룹 참가/나가기

#### 통계
- 월별 통계 조회
- 카테고리별 통계 (Pie Chart)
- 일별 추이 (Line Chart)
- 기간 선택 (current-month, last-month 등)

#### 예산 관리
- 예산 목록 조회
- 예산 생성/수정/삭제 (월별)
- 예산 현황 조회 (예산 대비 지출)

#### 반복 규칙
- 반복 규칙 목록 조회
- 반복 규칙 생성/수정/삭제
- 날짜 범위 처리
- 거래 생성

#### 잔액 조회
- 현재 잔액 조회
- 예상 잔액 조회 (미래 N개월)
- 월별 추이 그래프

#### 설정
- 알림 설정 (on/off)
- 사용자 설정 저장/불러오기
- 앱 정보 확인 (버전, 라이센스)

## 📋 현재 구현 상태

### ✅ 완료된 기능

#### 화면 구성
- ✅ 로그인 화면 (BLoC + API 연동)
- ✅ 회원가입 화면 (폼 검증 + 자동 로그인)
- ✅ 비밀번호 찾기 화면
- ✅ 대시보드 화면 (요약 카드, 최근 거래, 프로필/거래 상세 이동)
- ✅ 거래 내역 리스트 화면 (검색, 필터, 정렬, 무한 스크롤)
- ✅ 거래 상세 화면 (수정/삭제)
- ✅ 통계 화면 (PieChart, LineChart)
- ✅ 프로필 화면 (설정, 로그아웃, 앱 정보)
- ✅ 카테고리 관리 화면 (CRUD, 색상 선택, 예산 설정)
- ✅ 그룹 관리 화면 (CRUD, 초대 코드 생성 및 복사)
- ✅ 예산 관리 화면 (월별 예산 CRUD, 예산 현황)
- ✅ 반복 규칙 관리 화면 (CRUD, 날짜 범위 처리)
- ✅ 잔액 조회 화면 (현재/예상 잔액, 월별 추이)

#### 아키텍처
- ✅ BLoC 패턴 (Auth, Transaction, Category, Statistics, Group, Settings, Budget, RecurringRule, Balance)
- ✅ Repository 패턴 (9개 Repository)
- ✅ Dependency Injection
- ✅ Clean Architecture (Data, Domain, Presentation)
- ✅ 자동 인증 토큰 관리 (AuthInterceptor)
- ✅ 환경변수 지원 (AppConfig)
- ✅ 페이지네이션 (무한 스크롤)

#### API 연동
- ✅ Auth API (로그인, 회원가입, 프로필, 비밀번호 변경/찾기/재설정, 로그아웃, 토큰 갱신)
- ✅ Transaction API (CRUD, 검색, 필터, 페이지네이션)
- ✅ Category API (CRUD, 색상, 예산)
- ✅ Statistics API (통계 조회, groupId 지원, 기간 필터)
- ✅ Group API (CRUD, 초대 코드 생성/복사, 참가/나가기)
- ✅ Settings API (조회/수정/초기화)
- ✅ Balance API (잔액 조회, 예상 잔액, 월별 추이)
- ✅ Budget API (예산 CRUD, 예산 현황)
- ✅ Recurring Rule API (반복 규칙 CRUD, 거래 생성)

#### 디자인
- ✅ Material Design 3
- ✅ Google Fonts (Noto Sans)
- ✅ M3 Rounded Corners
- ✅ M3 Color Scheme
- ✅ M3 Typography
- ✅ Dark Theme 지원

## 🛠️ 기술 스택

- **언어**: Dart 3.x
- **프레임워크**: Flutter 3.x
- **상태 관리**: BLoC Pattern (flutter_bloc)
- **네트워크**: Dio
- **스토리지**: SharedPreferences
- **차트**: fl_chart
- **색상 선택**: flutter_colorpicker
- **폰트**: Google Fonts (Noto Sans)
- **디자인**: Material Design 3

## 📚 문서

프로젝트 상세 현황은 `SUMMARY.md`를 참고하세요.

## 🔧 환경변수 설정

API Base URL을 환경변수로 설정하려면:

```bash
# 실행 시 환경변수 전달
flutter run --dart-define=API_BASE_URL=http://your-server:8000

# 빌드 시 환경변수 전달
flutter build apk --dart-define=API_BASE_URL=https://api.example.com
```

## 📝 주요 기능

1. **거래 관리**: 거래 생성, 수정, 삭제, 검색, 필터링, 무한 스크롤
2. **카테고리 관리**: 카테고리 CRUD, 색상 설정, 예산 설정
3. **통계**: 월별/기간별 통계, 카테고리별 분석, 추이 그래프
4. **그룹 관리**: 그룹 생성/참가, 초대 코드 생성 및 클립보드 복사
5. **예산 관리**: 월별 예산 CRUD, 예산 대비 지출 현황
6. **반복 규칙**: 반복 거래 규칙 CRUD, 날짜 범위 처리, 자동 거래 생성
7. **잔액 조회**: 현재/예상 잔액, 월별 추이 그래프
8. **프로필 관리**: 프로필 수정, 비밀번호 변경/찾기, 알림 설정, 앱 정보
9. **자동 인증**: JWT 토큰 자동 관리 및 갱신

## 📱 Android 에뮬레이터 실행 방법

### 1. 에뮬레이터 생성 (Android Studio)
1. **Android Studio > Tools > Device Manager**
2. **Create Device** 클릭
3. **Pixel 6 또는 Pixel 7** 선택 (Galaxy S25와 유사한 크기)
4. **System Image: API 35 (Android 15)** 선택
5. **arm64-v8a** 아키텍처 선택 (Apple Silicon 맥)
6. **Finish** 클릭

### 2. 에뮬레이터 실행
```bash
# 에뮬레이터 목록 확인
flutter emulators

# 에뮬레이터 실행
flutter emulators --launch Pixel_7

# 또는 직접 실행
flutter emulators --launch <emulator_id>
```

### 3. 앱 실행 (에뮬레이터)
```bash
cd /Users/gary/Documents/workspace/household-ledger-android

# 에뮬레이터에서 실행 (로컬 서버)
flutter run -d android --dart-define=API_BASE_URL=http://10.0.2.2:8000

# 실제 기기에서 실행 (네트워크 IP)
flutter run -d android --dart-define=API_BASE_URL=http://172.30.1.53:8000
```

### 4. 연결 정보
- **에뮬레이터에서 로컬 서버 접속**: `http://10.0.2.2:8000`
  - Android 에뮬레이터는 `localhost`를 사용할 수 없습니다
  - `10.0.2.2`는 호스트 머신의 localhost를 가리킵니다
- **실제 기기에서 로컬 서버 접속**: `http://<서버 IP>:8000`
  - 예: `http://172.30.1.53:8000` (네트워크 IP 확인 필요)

### 5. 서버 실행 확인
```bash
# 서버가 실행 중인지 확인
curl http://localhost:8000/health

# 데이터베이스 실행 확인
docker ps | grep household-ledger-db
```

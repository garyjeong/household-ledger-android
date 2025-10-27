# 📱 Household Ledger Android

**신혼부부 가계부 안드로이드 앱**

## 📋 프로젝트 개요

Google Play Store에 배포 가능한 Kotlin 안드로이드 앱입니다.

### 주요 특징
- ✅ Jetpack Compose 기반 최신 UI
- ✅ MVVM + Clean Architecture
- ✅ 오프라인 모드 지원 (Room DB)
- ✅ 실시간 데이터 동기화
- ✅ 신혼부부 특화 기능

## 🛠 기술 스택

### 프론트엔드
- **Kotlin** 1.9+
- **Jetpack Compose** - 선언적 UI
- **ViewModel** + **StateFlow** - 상태 관리
- **Navigation Compose** - 화면 전환
- **Hilt/Koin** - 의존성 주입

### 데이터 계층
- **Retrofit** + **OkHttp** - HTTP 클라이언트
- **Room** - 로컬 데이터베이스
- **Coroutines** + **Flow** - 비동기 처리
- **DataStore** - 설정 저장

### 유틸리티
- **Coil** - 이미지 로딩
- **Timber** - 로깅
- **Material Design 3** - 디자인 시스템

## 📂 프로젝트 구조

```
house-hold-ledger-android/
├── app/
│   └── src/main/
│       ├── java/com/householdledger/app/
│       │   ├── MainActivity.kt
│       │   ├── di/                 # 의존성 주입
│       │   ├── ui/                 # UI 레이어
│       │   │   ├── auth/
│       │   │   ├── dashboard/
│       │   │   ├── transactions/
│       │   │   ├── statistics/
│       │   │   └── profile/
│       │   ├── domain/            # 도메인 레이어
│       │   │   ├── model/
│       │   │   └── usecase/
│       │   └── data/              # 데이터 레이어
│       │       ├── local/
│       │       ├── remote/
│       │       └── repository/
│       └── res/
│           ├── layout/
│           ├── drawable/
│           └── values/
├── build.gradle.kts
└── settings.gradle.kts
```

## 📱 주요 화면

### 인증
- **Login** - 로그인 화면
- **Signup** - 회원가입 화면
- **ForgotPassword** - 비밀번호 찾기

### 메인
- **Dashboard** - 월별 요약 및 빠른 입력
- **Transactions** - 거래 내역 목록 및 상세
- **Statistics** - 카테고리별 차트 및 분석
- **Profile** - 프로필 및 설정

## 🎨 UI/UX

### 디자인 시스템
- Material Design 3 적용
- 신혼부부 특화 색상 팔레트
- 다크 모드 자동 지원
- 24dp 그리드 시스템

### 주요 기능
- ✨ Swipe-to-Delete 제스처
- 🔄 Pull-to-Refresh
- 📊 다양한 차트 (Pie, Line)
- 🎯 빠른 입력 FloatingActionButton
- 🔍 고급 필터링 및 검색

## 🚀 시작하기

### 사전 요구사항
- Android Studio Hedgehog+
- JDK 17+
- Android SDK (API 24+)

### 설치 및 실행

```bash
# 1. 저장소 클론
git clone <repository-url>
cd house-hold-ledger-android

# 2. Android Studio에서 프로젝트 열기
# File → Open → 프로젝트 선택

# 3. Gradle 동기화
# Android Studio가 자동으로 Sync

# 4. 실행
# 디바이스/에뮬레이터 연결 후 Run 버튼 클릭
```

### 환경 설정
- `local.properties`에 SDK 경로 설정
- FastAPI 서버 URL 설정 (BuildConfig)

## 🧪 테스트

```bash
# Unit Tests
./gradlew test

# Instrumented Tests
./gradlew connectedAndroidTest

# 모든 테스트
./gradlew test connectedAndroidTest
```

## 📦 빌드

### Debug 빌드
```bash
./gradlew assembleDebug
```

### Release 빌드
```bash
# 1. keystore 생성
keytool -genkey -v -keystore household-ledger-key.jks

# 2. 서명 설정 (app/build.gradle.kts)
# 3. 빌드
./gradlew assembleRelease

# APK 출력: app/build/outputs/apk/release/
```

## 🚢 Google Play 배포

### 준비 작업
1. 앱 아이콘 생성 (모든 밀도)
2. 스크린샷 제작 (최소 2개)
3. Feature Graphic (1024x500)
4. 스토어 설명 작성
5. 개인정보처리방침 URL

### 배포 과정
1. Google Play Console 등록
2. 앱 정보 입력
3. APK/AAB 업로드
4. 콘텐츠 등급 설정
5. 가격 및 배포 국가 선택
6. 심사 제출

## 🧩 통합 API

FastAPI 백엔드 서버와 통신합니다.

### 주요 API
- `POST /api/v1/auth/login` - 로그인
- `GET /api/v1/transactions` - 거래 목록
- `POST /api/v1/transactions` - 거래 생성
- `GET /api/v1/statistics` - 통계 조회

자세한 API 명세는 [Swagger 문서](../house-hold-ledger-server/docs/swagger.json) 참조

## 📝 개발 가이드

자세한 작업 목록은 [TODO-ANDROID.md](./TODO-ANDROID.md)를 참고하세요.

### 아키텍처 패턴
- **MVVM**: ViewModel 기반 상태 관리
- **Clean Architecture**: 계층 분리 (UI, Domain, Data)
- **Repository Pattern**: 데이터 소스 추상화

### 코딩 가이드
- Kotlin Coding Conventions 준수
- ktlint, detekt 사용
- 최소 API 24 타겟

## 🐛 문제 해결

### 일반적인 이슈
- **Gradle 동기화 실패**: SDK 경로 확인
- **빌드 실패**: 프로젝트 Clean 후 Rebuild
- **메모리 부족**: 프로젝트 설정에서 힙 증가

## 📚 참고 문서

- [기존 웹앱 프로젝트](../household-ledger/README.md)
- [FastAPI 백엔드](../house-hold-ledger-server/README.md)
- [Android 개발자 문서](https://developer.android.com/)

## 📞 문의

- GitHub Issues: 이슈 등록
- PR 제출: Branch 생성 후 Pull Request

---

**작성자**: Development Team  
**최종 업데이트**: 2025.01


# 📱 Flutter 모바일 앱 개발 TODO

**시작일**: 2025년 10월  
**목표**: Google Play 배포 가능한 MVP 앱  
**예상 기간**: 6주 (Phase 1: 3주 + Phase 2: 3주)

---

## 📊 프로젝트 현황

### 기존 자산
- ✅ **웹앱 (household-ledger)**: 완성된 UI/UX 디자인
- ✅ **FastAPI 백엔드**: 완료 (http://localhost:8000)
- ✅ **API 명세**: Swagger 문서 제공

### 개발 목표
- 🎯 **기술 스택**: Flutter (Dart)
- 🎯 **아키텍처**: BLoC Pattern + Clean Architecture
- 🎯 **상태 관리**: flutter_bloc
- 🎯 **로컬 DB**: Hive / SharedPreferences
- 🎯 **네트워크**: http + dio

---

## ✅ Phase 1 (Week 1-3): 프로젝트 초기화 및 인증

### 🏗️ Week 1: Flutter 프로젝트 초기화

#### 프로젝트 생성
- [ ] Flutter 프로젝트 생성
  ```bash
  flutter create household_ledger_app --org com.householdledger --platforms android
  cd household_ledger_app
  ```

#### 의존성 추가 (`pubspec.yaml`)
- [ ] 상태 관리 (BLoC)
  ```yaml
  dependencies:
    flutter_bloc: ^8.1.3
    equatable: ^2.0.5
  ```

- [ ] 네트워킹 (HTTP + Dio)
  ```yaml
    http: ^1.1.0
    dio: ^5.4.0
    dio_interceptors: ^5.4.0
  ```

- [ ] 로컬 DB (Hive)
  ```yaml
    hive: ^2.2.3
    hive_flutter: ^1.1.0
    path_provider: ^2.1.1
  ```

- [ ] 인증 & 보안
  ```yaml
    flutter_secure_storage: ^9.0.0
    shared_preferences: ^2.2.2
  ```

- [ ] UI/UX
  ```yaml
    google_fonts: ^6.1.0
    flutter_svg: ^2.0.9
    shimmer: ^3.0.0
    cached_network_image: ^3.3.0
  ```

- [ ] 차트
  ```yaml
    fl_chart: ^0.66.0
  ```

- [ ] 유틸리티
  ```yaml
    intl: ^0.19.0
    logger: ^2.0.0
  ```

#### 디렉토리 구조 생성
- [ ] Flutter 프로젝트 구조
```
lib/
├── main.dart
├── app.dart
├── config/
│   └── app_config.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       ├── validators.dart
│       └── extensions.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── transaction_model.dart
│   │   └── category_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── transaction_repository.dart
│   │   └── category_repository.dart
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── auth_api.dart
│   │   │   └── transaction_api.dart
│   │   └── local/
│   │       ├── local_storage.dart
│   │       └── cache_manager.dart
│   └── providers/
│       └── http_client.dart
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── transaction.dart
│   │   └── category.dart
│   ├── repositories/
│   │   └── i_auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       └── get_transactions_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth/
    │   │   ├── auth_bloc.dart
    │   │   └── auth_state.dart
    │   └── transaction/
    │       ├── transaction_bloc.dart
    │       └── transaction_state.dart
    ├── pages/
    │   ├── login/
    │   │   ├── login_page.dart
    │   │   └── widgets/
    │   ├── dashboard/
    │   │   ├── dashboard_page.dart
    │   │   └── widgets/
    │   ├── transactions/
    │   │   ├── transaction_list_page.dart
    │   │   └── widgets/
    │   ├── statistics/
    │   │   ├── statistics_page.dart
    │   │   └── widgets/
    │   └── profile/
    │       ├── profile_page.dart
    │       └── widgets/
    └── widgets/
        ├── common/
        └── charts/
```

### 🔌 네트워크 계층 구축
- [ ] `data/remote/api/` 인터페이스 정의
  - Retrofit 인터페이스
  - 엔드포인트 메서드 (GET, POST, PUT, DELETE)
  
- [ ] OkHttp Interceptor 설정
  - 로그인 인터셉터 (Authorization 헤더 추가)
  - 로깅 인터셉터
  - 에러 처리

- [ ] DTO 클래스 정의
  - 요청/응답 데이터 클래스
  - Sealed 클래스로 Success/Error 상태 관리

### 💾 Room 데이터베이스 설정
- [ ] Entity 클래스 정의 (`@Entity`)
  - TransactionEntity
  - CategoryEntity
  - UserEntity (캐시용)
  
- [ ] DAO 인터페이스 정의 (`@Dao`)
  - TransactionDao (CRUD + suspend functions)
  - CategoryDao
  
- [ ] `AppDatabase.kt` 생성
  - Room Database 추상 클래스
  - 싱글톤 패턴

### 🔐 Security 및 Token 관리
- [ ] SharedPreferences 설정 (보안 저장소)
  - `EncryptedSharedPreferences` 사용
  - access_token, refresh_token 저장/조회
  
- [ ] Token Manager 유틸리티
  - 토큰 저장, 불러오기, 삭제
  - 만료 시간 체크

---

### 🎨 Week 6: 인증 화면 구현 (Jetpack Compose)

#### 로그인 화면
- [ ] `ui/auth/LoginScreen.kt`
  - 이메일/비밀번호 입력 필드
  - "로그인" 버튼
  - "회원가입" / "비밀번호 찾기" 링크
  - 로딩 상태 표시 (CircularProgressIndicator)
  
- [ ] `viewmodel/AuthViewModel.kt`
  - `login(email, password)` UseCase 호출
  - 성공 시 토큰 저장 및 Dashboard로 이동
  - 에러 처리 (Toast 메시지)
  - State 정의 (uiState, errorState)

#### 회원가입 화면
- [ ] `ui/auth/SignupScreen.kt`
  - 이메일, 비밀번호, 닉네임 입력
  - 비밀번호 확인 필드
  - Validation (형식 체크, 일치 여부)
  - "가입하기" 버튼
  
- [ ] AuthViewModel에 signup 로직 추가
  - 이메일 중복 체크 → 회원가입
  - 그룹 초대 코드 입력 옵션

#### 비밀번호 찾기 화면 (선택)
- [ ] `ui/auth/ForgotPasswordScreen.kt`
  - 이메일 입력만으로 간단히 구성

### 🧭 Navigation 설정
- [ ] NavGraph 구성 (`ui/Navigation.kt`)
  - 시작 화면: LoginScreen
  - 인증 플로우: Login → Signup/ForgotPassword
  - 메인 플로우: Dashboard ↔ Transactions ↔ Statistics ↔ Profile

- [ ] MainActivity.kt 수정
  - NavHost 설정
  - 인증 상태에 따른 화면 전환

---

### 👤 Week 7: 대시보드 기본 구조

#### 대시보드 레이아웃
- [ ] `ui/dashboard/DashboardScreen.kt`
  - Top App Bar (프로필, 그룹명)
  - 월별 요약 카드
  - 빠른 입력 FloatingActionButton
  - 최근 거래 목록 (LazyColumn)
  
- [ ] `viewmodel/DashboardViewModel.kt`
  - 월별 통계 조회 UseCase
  - 최근 거래 목록 조회
  - StateFlow로 UI 상태 관리

#### 프로필 화면
- [ ] `ui/profile/ProfileScreen.kt`
  - 사용자 정보 표시 (nickname, 이메일)
  - 그룹 정보 (멤버 목록)
  - 설정 항목 (알림, 로그아웃)
  
- [ ] `viewmodel/ProfileViewModel.kt`
  - 프로필 정보 조회
  - 로그아웃 처리
  - 그룹 탈퇴 처리

### 📱 Bottom Navigation 설정
- [ ] BottomNavigationBar 컴포저블
  - 4개 탭: Dashboard, Transactions, Statistics, Profile
  - 아이콘: Home, Receipt, Chart, Person
  - 현재 화면 하이라이트

- [ ] MainActivity에 BottomNav 통합
  - NavGraph와 연결
  - 각 탭별 화면 정의

---

### 🔗 Week 8: API 연동 및 통합 테스트

#### Repository 구현
- [ ] `data/repository/AuthRepository.kt`
  - Remote: API 호출
  - Local: 토큰 저장
  - 에러 처리 및 재시도 로직

- [ ] `data/repository/TransactionRepository.kt`
  - Remote: API 호출
  - Local: Room DB 캐시
  - Offline First 전략 (캐시 우선)

- [ ] `data/repository/CategoryRepository.kt`
  - 카테고리 목록 캐싱
  - 그룹별 필터링

#### UseCase 구현
- [ ] `domain/usecase/LoginUseCase.kt`
  - AuthRepository 호출
  - TokenManager에 토큰 저장
  - 결과 반환 (Sealed Class)

- [ ] `domain/usecase/GetTransactionsUseCase.kt`
  - Repository 호출
  - 데이터 정제 및 반환

#### Koin 모듈 설정
- [ ] `NetworkModule.kt`
  - Retrofit, OkHttp Client
  - API 인터페이스 인스턴스

- [ ] `RepositoryModule.kt`
  - Repository 구현체 제공

- [ ] `UseCaseModule.kt`
  - UseCase 구현체 제공

- [ ] `ViewModelModule.kt`
  - ViewModel 제공 (by viewModel())

#### 통합 테스트
- [ ] 실제 FastAPI 서버와 연동
- [ ] 로그인 → 토큰 저장 → API 호출 플로우
- [ ] 네트워크 오류 시 에러 처리
- [ ] 토큰 만료 시 재로그인 유도

---

## ✅ Phase 3 (Week 9-12): 핵심 기능 완성

### 💸 Week 9: 거래 입력 및 조회 기능

#### 거래 목록 화면
- [ ] `ui/transactions/TransactionListScreen.kt`
  - LazyColumn + pull-to-refresh
  - 필터 (기간, 카테고리, 타입)
  - 정렬 옵션
  - Swipe-to-Delete 제스처
  
- [ ] `viewmodel/TransactionViewModel.kt`
  - 거래 목록 조회 (페이징)
  - 필터/정렬 상태 관리
  - 삭제 로직

#### 거래 입력 다이얼로그
- [ ] `ui/transactions/TransactionDialog.kt`
  - BottomSheet 형태
  - 필드: 금액, 카테고리, 날짜, 메모
  - 타입 선택 (수입/지출)
  - "저장" 버튼
  
- [ ] TransactionViewModel에 createTransaction 추가

#### 거래 상세 화면
- [ ] `ui/transactions/TransactionDetailScreen.kt`
  - 거래 정보 표시
  - 수정/삭제 버튼
  - 첨부파일 이미지 뷰어

### 📊 Week 10: 통계 및 차트 화면

#### 통계 화면
- [ ] `ui/statistics/StatisticsScreen.kt`
  - 월별 탭 선택
  - 수입/지출 총액 카드
  - 카테고리별 차트 (Pie Chart)
  - 월별 트렌드 그래프 (Line Chart)
  
- [ ] Chart 라이브러리 통합
  - MPAndroidChart 또는 Jetpack Compose용 차트 라이브러리
  - 애니메이션 적용

- [ ] `viewmodel/StatisticsViewModel.kt`
  - API 호출
  - 데이터 가공 (차트용)
  - 필터링 로직

### ⚙️ Week 11: 프로필 및 설정 화면 완성

#### 프로필 상세
- [ ] 프로필 정보 수정
  - 닉네임 변경
  - 프로필 이미지 업로드
  
- [ ] 그룹 관리 화면
  - 그룹 멤버 목록
  - 그룹 이름 변경
  - 그룹 탈퇴

#### 설정 화면
- [ ] `ui/settings/SettingsScreen.kt`
  - 알림 설정 (스위치)
  - 다크 모드 (자동)
  - 계정 삭제 옵션
  - 로그아웃 버튼

#### 카테고리 관리
- [ ] `ui/categories/CategoryScreen.kt`
  - 카테고리 목록 (GridView)
  - 카테고리 추가 다이얼로그
  - 색상 선택
  - 예산 금액 설정

### 🚀 Week 12: 배포 준비 및 최적화

#### 프로덕션 빌드
- [ ] Release 버전 설정
  - `buildTypes { release {} }`
  - ProGuard/R8 설정
  - 코드 난독화

- [ ] 앱 서명 키 생성
  ```bash
  keytool -genkey -v -keystore household-ledger-key.jks
  ```

- [ ] `gradle.properties`에 서명 정보 설정
  - keystore 경로
  - 키 별칭 및 비밀번호
  - `.gitignore`에 추가

#### 성능 최적화
- [ ] 이미지 로딩 최적화
  - Coil 라이브러리 사용
  - 캐싱 전략
  - 리사이징

- [ ] 메모리 누수 체크
  - LeakCanary 통합
  - 프로파일링

- [ ] 앱 크기 최적화
  - 벡터 이미지 사용
  - APK Analyzer로 중복 리소스 제거

#### 에러 추적
- [ ] Firebase Crashlytics 통합
  - 빌드 설정
  - 크래시 자동 수집

- [ ] Analytics 통합 (선택)
  - 사용자 이벤트 추적
  - 화면 이동 로깅

#### Google Play 준비
- [ ] 앱 아이콘 (모든 크기)
  - `mipmap-mdpi/launcher_icon.png` 등
  - Adaptive Icon (API 26+)

- [ ] 스토어 리스팅 자료
  - 스크린샷 (최소 2개, 권장 8개)
    - 모바일: 1080 x 1920 (16:9)
  - 그래픽
    - Feature Graphic: 1024 x 500
    - Icon: 512 x 512

- [ ] 개인정보처리방침 작성
  - GitHub Pages 또는 별도 페이지
  - URL 준비

- [ ] 콘텐츠 등급
  - 12세 이상 (모든 사람 가능)

#### 심사 준비
- [ ] 테스트 체크리스트
  - [ ] 모든 화면 정상 작동
  - [ ] 인증 플로우 완성
  - [ ] 오프라인 모드 테스트
  - [ ] 다양한 기기 테스트 (3개 이상)
  - [ ] 다크 모드 테스트
  - [ ] 텍스트 크기 조정 테스트
  - [ ] 네트워크 오류 시나리오

- [ ] 알파/베타 테스트
  - TestFlight 유사 도구 또는 수동 배포
  - 테스터 피드백 수집 및 수정

---

## 🧪 테스트 전략

### Week 5: 테스트 인프라 구축

#### 의존성 추가 (`build.gradle.kts`)
- [ ] Test 의존성 추가
```kotlin
// Unit Test
testImplementation("junit:junit:4.13.2")
testImplementation("org.mockito:mockito-core:5.0.0")
testImplementation("org.mockito.kotlin:mockito-kotlin:5.0.0")
testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test")
testImplementation("app.cash.turbine:turbine") // Flow 테스트

// Instrumented Test
androidTestImplementation("androidx.compose.ui:ui-test-junit4")
androidTestImplementation("androidx.compose.ui:ui-test-manifest")
androidTestImplementation("androidx.test.ext:junit:1.1.5")
androidTestImplementation("androidx.test:runner:1.5.2")
androidTestImplementation("androidx.test:rules:1.5.0")
androidTestImplementation("org.mockito:mockito-android:5.0.0")
```

#### 테스트 디렉토리 구조
```
app/
├── src/
│   ├── test/          # Unit Tests
│   │   ├── kotlin/com/householdledger/
│   │   │   ├── domain/
│   │   │   │   ├── usecase/LoginUseCaseTest.kt
│   │   │   │   └── model/TransactionTest.kt
│   │   │   ├── data/
│   │   │   │   ├── repository/AuthRepositoryTest.kt
│   │   │   │   └── remote/dto/TransactionDTOTest.kt
│   │   │   └── utils/ValidationTest.kt
│   │   │
│   │   └── androidTest/ # Instrumented Tests
│   │       ├── kotlin/com/householdledger/
│   │       │   ├── ui/
│   │       │   │   ├── auth/LoginScreenTest.kt
│   │       │   │   └── transactions/TransactionScreenTest.kt
│   │       │   ├── database/
│   │       │   │   └── AppDatabaseTest.kt
│   │       │   └── e2e/
│   │       │       ├── AuthFlowTest.kt
│   │       │       └── TransactionFlowTest.kt
```

---

### Week 6-7: Unit Tests 작성

#### Domain Layer Tests
- [ ] **UseCase 테스트**
```kotlin
// LoginUseCaseTest.kt
@Test
fun `로그인 성공 - 유효한 자격증명`() = runTest {
    // Given
    val email = "test@example.com"
    val password = "password123"
    val expectedToken = "access_token"
    
    // When
    val result = loginUseCase(email, password)
    
    // Then
    assertTrue(result is Success)
    assertEquals(expectedToken, (result as Success).data.token)
}

@Test
fun `로그인 실패 - 잘못된 비밀번호`() = runTest {
    // Given
    val email = "test@example.com"
    val password = "wrongpassword"
    
    // When
    val result = loginUseCase(email, password)
    
    // Then
    assertTrue(result is Error)
    assertEquals("Invalid credentials", (result as Error).message)
}
```

- [ ] **Model 테스트**
  - Validation 로직 테스트
  - 데이터 변환 테스트

- [ ] **Util 함수 테스트**
```kotlin
// ValidationTest.kt
@Test
fun `유효한 이메일 형식 검증`() {
    assertTrue(isValidEmail("test@example.com"))
    assertFalse(isValidEmail("invalid-email"))
}
```

#### Data Layer Tests
- [ ] **Repository 테스트**
```kotlin
// AuthRepositoryTest.kt
@Test
fun `토큰 저장 및 조회 테스트`() = runTest {
    // Given
    val token = "test_token"
    
    // When
    authRepository.saveToken(token)
    
    // Then
    assertEquals(token, authRepository.getToken())
}
```

- [ ] **DTO 변환 테스트**
  - API Response → Domain Model
  - Domain Model → API Request

---

### Week 8: Instrumented Tests 작성

#### UI Tests
- [ ] **Compose UI 테스트**
```kotlin
// LoginScreenTest.kt
@Test
fun `로그인 버튼 클릭시 로딩 표시`() {
    composeTestRule.setContent {
        LoginScreen(viewModel)
    }
    
    // When
    composeTestRule.onNodeWithText("로그인").performClick()
    
    // Then
    composeTestRule.onNodeWithTag("CircularProgressIndicator").assertIsDisplayed()
}
```

- [ ] **Navigation 테스트**
```kotlin
@Test
fun `로그인 성공시 대시보드로 이동`() {
    // When
    simulateLogin()
    
    // Then
    assertCurrentDestination("dashboard")
}
```

#### Database Tests
- [ ] **Room 테스트**
```kotlin
// AppDatabaseTest.kt
@Test
fun `거래 저장 및 조회 테스트`() = runTest {
    // Given
    val transaction = Transaction(...)
    
    // When
    transactionDao.insert(transaction)
    
    // Then
    val result = transactionDao.getAll()
    assertEquals(1, result.size)
    assertEquals(transaction.id, result[0].id)
}
```

---

### Week 9-10: 통합 테스트

#### API 통합 테스트
- [ ] **Mock Server 설정**
  - MockWebServer 사용
  - 다양한 응답 시나리오 테스트
```kotlin
// AuthApiTest.kt
@Test
fun `API 호출 성공 테스트`() = runTest {
    // Given
    mockWebServer.enqueue(
        MockResponse()
            .setResponseCode(200)
            .setBody(jsonResponse)
    )
    
    // When
    val result = authApi.login(email, password)
    
    // Then
    assertNotNull(result)
    assertEquals(expectedToken, result.token)
}
```

#### End-to-End Tests
- [ ] **인증 플로우 E2E**
```kotlin
// AuthFlowTest.kt
@Test
fun `회원가입 → 로그인 → 대시보드 이동 전체 플로우`() {
    // 1. 회원가입
    register(user)
    verifySuccessMessage()
    
    // 2. 로그인
    login(email, password)
    verifyTokenSaved()
    
    // 3. 대시보드 이동
    verifyDashboardShown()
}
```

- [ ] **거래 CRUD E2E**
```kotlin
// TransactionFlowTest.kt
@Test
fun `거래 생성 → 조회 → 수정 → 삭제 전체 플로우`() {
    // 1. 생성
    createTransaction(transaction)
    verifyTransactionCreated()
    
    // 2. 조회
    val transactions = getTransactions()
    assertTrue(transactions.contains(transaction))
    
    // 3. 수정
    updateTransaction(updatedTransaction)
    verifyTransactionUpdated()
    
    // 4. 삭제
    deleteTransaction(transactionId)
    verifyTransactionDeleted()
}
```

---

### Week 11-12: 로컬 기기 테스트

#### 실제 기기 테스트 체크리스트
- [ ] **물리 기기 연결**
```bash
# USB 디버깅 활성화 후
adb devices

# 앱 설치
./gradlew installDebug

# 앱 실행
adb shell am start -n com.householdledger.app/.MainActivity

# 로그 확인
adb logcat -s "HouseholdLedger"
```

- [ ] **테스트 시나리오**
  - [ ] 로그인/회원가입 플로우
  - [ ] 거래 생성/수정/삭제
  - [ ] 통계 화면 로딩
  - [ ] 오프라인 모드 동작
  - [ ] 푸시 알림 받기
  - [ ] 다크 모드 전환
  - [ ] 화면 회전 대응

- [ ] **성능 테스트**
```kotlin
// Benchmark 테스트 (선택)
@Test
fun `거래 목록 로딩 시간 측정`() {
    measureTimeMillis {
        viewModel.loadTransactions()
    }.let { time ->
        assertTrue(time < 1000, "로딩 시간은 1초 이하여야 함")
    }
}
```

#### 다양한 기기 테스트
- [ ] **기기 목록**
  - Pixel 6 Pro (API 31)
  - Samsung Galaxy S21 (API 30)
  - Xiaomi Redmi Note (API 28) - 구형 기기
  - 에뮬레이터 (API 24) - 최소 SDK

- [ ] **크래시 리포트 수집**
  - Firebase Crashlytics 연동
  - 실제 크래시 케이스 수집 및 수정

#### 배포 전 테스트
- [ ] **Release 빌드 테스트**
```bash
# Release 빌드
./gradlew assembleRelease

# APK 서명 확인
jarsigner -verify -certs app-release.apk

# 기기에 설치 및 테스트
adb install app-release.apk
```

- [ ] **Play Console 테스트**
  - Internal Testing 그룹에 배포
  - 테스터 초대 및 피드백 수집

---

## 🧪 테스트 커버리지 목표

### 단위 테스트 (Unit Tests)
- **목표**: 80% 이상
- **테스트 대상**:
  - ViewModel 로직
  - Repository 로직
  - UseCase 로직
  - Utils 함수

### 통합 테스트 (Integration Tests)
- **목표**: 60% 이상
- **테스트 대상**:
  - API 통합
  - Room DB 통합
  - Navigation 통합

### E2E 테스트 (End-to-End Tests)
- **목표**: 핵심 플로우 100%
- **테스트 대상**:
  - 인증 플로우
  - 거래 CRUD 플로우
  - 통계 조회 플로우

### 커버리지 측정
```bash
# 커버리지 리포트 생성
./gradlew testDebugUnitTestCoverage

# 보고서 확인
open app/build/reports/jacoco/
```

---

## 📱 로컬 기기 테스트 가이드

### 개발 환경 설정
1. **USB 디버깅 활성화**
   - 설정 → 개발자 옵션 → USB 디버깅 켜기

2. **ADB 설치 확인**
```bash
adb version
# Android Debug Bridge version 1.0.41
```

3. **기기 연결 확인**
```bash
adb devices
# List of devices attached
# ABC123 device
```

### 테스트 실행 방법
```bash
# Unit Tests
./gradlew test

# Instrumented Tests (에뮬레이터/기기 필요)
./gradlew connectedAndroidTest

# 특정 테스트 실행
./gradlew test --tests "*.LoginUseCaseTest"

# UI Tests
./gradlew connectedDebugAndroidTest
```

### 디버깅
- **Android Studio**: Breakpoint 설정 및 디버거 연결
- **로그 확인**: Logcat 탭에서 필터링
- **네트워크 로그**: Charles Proxy 또는 Wireshark 사용

---

## ✅ Definition of Done

- [ ] 모든 MVP 기능 구현 완료
- [ ] UI/UX 웹앱과 일관성 유지
- [ ] FastAPI 서버와 완전 통신
- [ ] 오프라인 모드 안정적 동작
- [ ] 테스트 커버리지 70% 이상
- [ ] 앱 크기 50MB 이하
- [ ] Google Play 심사 통과 가능
- [ ] 성능 지표 달성
  - 앱 시작 시간 < 2초
  - 화면 전환 < 300ms
  - 메모리 사용 < 150MB

---

**다음 단계**: Google Play Console 등록 및 앱 출시 🎉


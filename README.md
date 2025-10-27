# 💑 신혼부부 가계부 - Flutter 모바일 앱

**🔄 기술 스택 변경**: Kotlin → Flutter  
**📅 프로젝트 기간**: 6주  
**🎯 목표**: Google Play 배포 가능한 MVP 앱

---

## 🚀 프로젝트 개요

신혼부부가 각자 입력해도 자동으로 하나의 가계부로 묶여 지출을 투명하게 공유할 수 있는 **모바일 가계부 앱**입니다.

### ✨ 주요 특징
- **Flutter 기반**: iOS, Android 동시 지원
- **BLoC Pattern**: 명확한 상태 관리
- **Clean Architecture**: 유지보수 가능한 구조
- **오프라인 지원**: Hive DB로 로컬 캐싱
- **실시간 동기화**: FastAPI 백엔드 연동

---

## 🛠 기술 스택

### Frontend
- **Flutter** 3.x - 크로스 플랫폼 프레임워크
- **Dart** 3.x - 프로그래밍 언어
- **flutter_bloc** - 상태 관리
- **Hive** - 로컬 DB
- **dio** - HTTP 클라이언트
- **fl_chart** - 차트 라이브러리

### Backend (기존)
- **FastAPI** - REST API 서버
- **MySQL** - 데이터베이스
- **SQLAlchemy** - ORM
- **JWT** - 인증

---

## 📁 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── app.dart                     # MaterialApp 설정
├── config/
│   └── app_config.dart         # 앱 설정 (API URL 등)
├── core/
│   ├── theme/                   # 다크모드, 컬러
│   ├── constants/              # 상수
│   └── utils/                   # 유틸리티
├── data/
│   ├── models/                  # JSON 모델
│   ├── repositories/            # Repository 구현
│   ├── datasources/            # API, DB
│   └── providers/              # HTTP Client
├── domain/
│   ├── entities/                # 순수 도메인 모델
│   ├── repositories/            # Repository 인터페이스
│   └── usecases/               # 비즈니스 로직
└── presentation/
    ├── bloc/                    # BLoC (상태 관리)
    ├── pages/                  # 화면
    └── widgets/                 # 재사용 위젯
```

---

## 🎨 UI/UX 설계

### 주요 화면
1. **로그인/회원가입** - 인증
2. **대시보드** - 월별 요약, 빠른 입력
3. **거래 내역** - 리스트, 필터, 검색
4. **통계** - 차트, 카테고리 분석
5. **프로필** - 설정, 카테고리 관리

### 디자인 시스템
- **Primary**: 보라색 (`#7C3AED`)
- **Secondary**: 핑크색 (`#EC4899`)
- **Material Design 3**
- **반응형 레이아웃**

자세한 내용은 [DESIGN.md](./DESIGN.md) 참고

---

## 🏗 개발 계획

### Phase 1 (Week 1-3): 기본 구조
- [x] Flutter 프로젝트 초기화
- [ ] 의존성 설정
- [ ] 디렉토리 구조 생성
- [ ] 네트워크 계층 구축
- [ ] 인증 화면 구현

### Phase 2 (Week 4-6): 핵심 기능
- [ ] 대시보드 구현
- [ ] 거래 입력/조회
- [ ] 통계 화면
- [ ] 프로필 화면

---

## 🚀 빠른 시작

### 필수 요구사항
- **Flutter** 3.x
- **Dart** 3.x
- **Android SDK** (API 24+)
- **FastAPI 서버** (localhost:8000)

### 설치 및 실행

```bash
# 1. Flutter 설치 확인
flutter doctor

# 2. 프로젝트 생성 (예정)
flutter create household_ledger_app --org com.householdledger

# 3. 의존성 설치
flutter pub get

# 4. 개발 서버 실행
flutter run
```

---

## 📱 API 연동

### 기본 설정
```dart
// config/app_config.dart
class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';
}
```

### API 엔드포인트
- `POST /api/v1/auth/login` - 로그인
- `POST /api/v1/auth/signup` - 회원가입
- `GET /api/v1/transactions` - 거래 조회
- `POST /api/v1/transactions` - 거래 생성
- `GET /api/v1/statistics` - 통계 조회

---

## 🧪 테스트 전략

### Unit Tests
- Domain 로직 (UseCase)
- Repository 로직
- 유틸리티 함수

### Widget Tests
- 화면 렌더링
- 사용자 인터랙션

### Integration Tests
- 인증 플로우
- 거래 CRUD 플로우

---

## 📦 빌드 및 배포

### Android APK
```bash
flutter build apk --release
```

### Google Play
```bash
flutter build appbundle --release
# Upload to Play Console
```

---

## 🔄 개발 진행 상황

### ✅ 완료
- [x] Flutter 프로젝트 계획 수립
- [x] UI/UX 설계 완료
- [x] 기술 스택 선정

### 🚧 진행 중
- [ ] 프로젝트 초기화

### 📋 예정
- [ ] 인증 구현
- [ ] 대시보드 구현
- [ ] 거래 관리
- [ ] 통계 화면

---

## 📚 문서

- [TODO 목록](./TODO-ANDROID.md) - 상세 개발 계획
- [UI/UX 설계](./DESIGN.md) - 화면별 디자인
- [Server README](../household-ledger-server/README.md) - 백엔드 API

---

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

**💑 신혼부부를 위한 가장 간단한 가계부 앱** ✨

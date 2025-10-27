# Household Ledger Android - 개발 현황

## ✅ 완료된 기능

### 1. 화면 구성
- ✅ 로그인 화면 (BLoC + API 연동)
- ✅ 회원가입 화면 (폼 검증)
- ✅ 대시보드 화면 (요약 카드, 거래 리스트)
- ✅ 거래 내역 리스트 화면 (필터, 새로고침)
- ✅ 통계 화면 (PieChart, LineChart)
- ✅ 프로필 화면 (설정, 로그아웃)
- ✅ 거래 입력 모달 (DraggableSheet)

### 2. 네비게이션
- ✅ BottomNavigationBar (4개 탭)
- ✅ AppRouter (화면 간 이동)
- ✅ AppBottomNavBar 컴포넌트

### 3. 아키텍처
- ✅ BLoC 패턴 (Auth)
- ✅ Repository 패턴
- ✅ Data Layer (API, Local Storage)
- ✅ Domain Layer (Entities)
- ✅ Presentation Layer (Pages, BLoC, Widgets)

### 4. 디자인
- ✅ Material Design 3
- ✅ Google Fonts (Noto Sans)
- ✅ M3 Rounded Corners
- ✅ M3 Color Scheme
- ✅ M3 Typography

### 5. API 클라이언트
- ✅ Auth API
- ✅ Transaction API
- ✅ Category API
- ✅ Statistics API
- ✅ HTTP Client (Dio)

## 📊 파일 구조

```
lib/
├── config/              # 앱 설정
├── core/               # 핵심 로직
│   ├── constants/      # 상수
│   ├── router/         # 라우팅
│   ├── theme/          # 테마
│   └── utils/          # 유틸리티
├── data/               # 데이터 계층
│   ├── datasources/    # 데이터 소스
│   └── repositories/   # 리포지토리
├── domain/             # 도메인 계층
│   └── entities/       # 엔티티
└── presentation/       # 프레젠테이션 계층
    ├── bloc/           # BLoC
    ├── pages/          # 페이지
    └── widgets/        # 위젯
```

총 **29개** Dart 파일

## 🚧 남은 작업

### 1. API 연동
- [ ] Transaction BLoC
- [ ] Category BLoC
- [ ] Statistics BLoC
- [ ] 실제 API 호출 테스트
- [ ] 에러 핸들링 강화

### 2. 데이터 처리
- [ ] 카테고리 목록 로드
- [ ] 거래 내역 CRUD
- [ ] 통계 데이터 계산
- [ ] 로컬 캐싱 (Hive)

### 3. 기능 추가
- [ ] 검색 기능
- [ ] 필터 기능
- [ ] 정렬 기능
- [ ] 무한 스크롤
- [ ] 그룹 관리

### 4. 테스트
- [ ] Unit Tests
- [ ] Widget Tests
- [ ] Integration Tests

### 5. 배포 준비
- [ ] 서버 연결 테스트
- [ ] Android Bundle 빌드
- [ ] Google Play 업로드

## 🎯 다음 단계

1. **API 연동**: 백엔드 서버와 실제 데이터 통신
2. **BLoC 구현**: Transaction, Category, Statistics
3. **테스트**: Unit/Widget 테스트 작성
4. **최적화**: 성능 및 UX 개선
5. **배포**: Google Play 스토어 업로드


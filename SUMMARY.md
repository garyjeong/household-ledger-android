# Household Ledger Android - 개발 현황

## ✅ 완료된 기능

### 1. 화면 구성
- ✅ 로그인 화면 (BLoC + API 연동)
- ✅ 회원가입 화면 (폼 검증 + 자동 로그인)
- ✅ 비밀번호 찾기 화면
- ✅ 대시보드 화면 (요약 카드, 거래 리스트)
- ✅ 거래 내역 리스트 화면 (검색, 필터, 정렬, 새로고침)
- ✅ 거래 상세 화면 (수정/삭제)
- ✅ 통계 화면 (PieChart, LineChart)
- ✅ 프로필 화면 (설정, 로그아웃, 프로필 수정)
- ✅ 거래 입력 모달 (DraggableSheet, 수정 모드 지원)
- ✅ 카테고리 관리 화면 (CRUD, 색상 선택, 예산 설정)
- ✅ 그룹 관리 화면 (CRUD, 초대 코드, 참가/나가기)

### 2. 네비게이션
- ✅ BottomNavigationBar (4개 탭)
- ✅ AppRouter (화면 간 이동)
- ✅ AppBottomNavBar 컴포넌트
- ✅ 화면 간 이동 연결 완료

### 3. 아키텍처
- ✅ BLoC 패턴 (Auth, Transaction, Category, Statistics, Group, Settings)
- ✅ Repository 패턴 (8개)
- ✅ Data Layer (API, Local Storage)
- ✅ Domain Layer (Entities)
- ✅ Presentation Layer (Pages, BLoC, Widgets)
- ✅ Dependency Injection 완성
- ✅ 자동 인증 토큰 관리 (AuthInterceptor)

### 4. 디자인
- ✅ Material Design 3
- ✅ Google Fonts (Noto Sans)
- ✅ M3 Rounded Corners
- ✅ M3 Color Scheme
- ✅ M3 Typography
- ✅ Dark Theme 지원

### 5. API 클라이언트
- ✅ Auth API (로그인, 회원가입, 프로필, 비밀번호 변경, 로그아웃, 토큰 갱신)
- ✅ Transaction API (CRUD, 검색, 필터)
- ✅ Category API (CRUD)
- ✅ Statistics API (통계 조회, groupId 지원)
- ✅ Group API (CRUD, 초대 코드, 참가/나가기)
- ✅ Settings API (조회/수정/초기화)
- ✅ Balance API (잔액 조회)
- ✅ Budget API (예산 관리)
- ✅ Recurring Rule API (반복 규칙)
- ✅ HTTP Client (Dio + AuthInterceptor)

### 6. 주요 기능
- ✅ 거래 검색 (메모, 가맹점)
- ✅ 거래 필터 (날짜 범위, 카테고리, 타입)
- ✅ 거래 정렬
- ✅ 카테고리 관리 (색상 선택, 예산 설정)
- ✅ 그룹 관리 (초대 코드 생성 및 복사)
- ✅ 알림 설정 (Settings API 연동)
- ✅ 프로필 수정 (닉네임, 이메일)
- ✅ 비밀번호 변경
- ✅ 클립보드 복사 (초대 코드)

## 📊 파일 구조

```
lib/
├── config/              # 앱 설정 (환경변수 지원)
├── core/               # 핵심 로직
│   ├── constants/      # 상수
│   ├── router/         # 라우팅
│   ├── theme/          # 테마
│   └── utils/          # 유틸리티 (DI)
├── data/               # 데이터 계층
│   ├── datasources/    # 데이터 소스 (8개 API)
│   └── repositories/   # 리포지토리 (8개)
├── domain/             # 도메인 계층
│   └── entities/       # 엔티티
└── presentation/       # 프레젠테이션 계층
    ├── bloc/           # BLoC (6개)
    ├── pages/          # 페이지 (12개)
    └── widgets/        # 위젯
```

총 **70개 이상** Dart 파일

## ✅ 완료된 작업

### UI-BLoC 연동
- ✅ Transaction BLoC를 UI에 연결
- ✅ Category BLoC를 UI에 연결
- ✅ Statistics BLoC를 UI에 연결
- ✅ Group BLoC를 UI에 연결
- ✅ Settings BLoC를 UI에 연결
- ✅ Dependency Injection 완성

### 데이터 처리
- ✅ 실제 API 호출 구현
- ✅ 에러 핸들링 강화
- ✅ 로딩 상태 표시
- ✅ 사용자 피드백 (SnackBar)

### 기능 추가
- ✅ 검색 기능 (거래 검색)
- ✅ 필터 기능 (날짜, 카테고리)
- ✅ 정렬 기능
- ✅ 그룹 관리 (CRUD, 초대 코드)
- ✅ 카테고리 관리 (CRUD, 색상, 예산)
- ✅ 프로필 관리 (수정, 비밀번호 변경)
- ✅ 알림 설정

## 🚧 향후 개선 사항

### 1. 성능 최적화
- [ ] 무한 스크롤 (페이지네이션)
- [ ] 이미지 캐싱
- [ ] 데이터 캐싱 전략

### 2. 추가 기능
- [ ] 정렬 기능 UI
- [ ] 거래 내보내기 (CSV, PDF)
- [ ] 예산 관리 페이지
- [ ] 반복 규칙 관리 페이지
- [ ] 잔액 조회 페이지

### 3. 테스트
- [ ] Unit Tests
- [ ] Widget Tests
- [ ] Integration Tests

### 4. 배포 준비
- [ ] 서버 연결 테스트
- [ ] Android Bundle 빌드
- [ ] Google Play 업로드
- [ ] App Icon 및 스플래시 화면

## 🎯 주요 성과

1. **완전한 아키텍처**: Clean Architecture + BLoC 패턴으로 확장 가능한 구조
2. **자동 인증 관리**: JWT 토큰 자동 관리 및 갱신
3. **완전한 CRUD**: 모든 주요 엔티티에 대한 CRUD 기능 구현
4. **사용자 경험**: 로딩 상태, 에러 처리, 성공 피드백 등 UX 개선
5. **환경변수 지원**: 개발/프로덕션 환경 분리 지원

## 📝 기술적 하이라이트

- **BLoC 패턴**: 6개의 BLoC으로 상태 관리
- **Repository 패턴**: 데이터 접근 추상화
- **의존성 주입**: 중앙 집중식 DI 관리
- **인터셉터**: 자동 인증 토큰 관리
- **Material Design 3**: 최신 디자인 시스템 적용
- **환경변수 지원**: 유연한 배포 환경 구성

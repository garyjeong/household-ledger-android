# 📱 Flutter 앱 UI/UX 설계 (Material Design 3)

**프로젝트**: 신혼부부 가계부 Flutter 앱  
**날짜**: 2025년 10월  
**플랫폼**: Flutter (iOS, Android)  
**디자인 시스템**: [Material Design 3](https://m3.material.io/)

---

## 🎨 Material Design 3 디자인 시스템

### 동적 컬러 팔레트 (Dynamic Color)
Material Design 3의 핵심인 동적 컬러 시스템을 적용합니다.

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Seed Color (기본 소스)
  static const Color seedColor = Color(0xFF7C3AED);  // 보라색
  
  // Primary Colors (M3 Color System)
  static const Color primary = Color(0xFF7C3AED);      // Primary
  static const Color onPrimary = Color(0xFFFFFFFF);     // On Primary (텍스트)
  static const Color primaryContainer = Color(0xFFE9D5FF);  // Container
  static const Color onPrimaryContainer = Color(0xFF1A0061); // On Container
  
  // Secondary Colors
  static const Color secondary = Color(0xFFEC4899);     // Secondary
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFD1E5); // Container
  static const Color onSecondaryContainer = Color(0xFF4A0018); // On Container
  
  // Tertiary Colors (선택적)
  static const Color tertiary = Color(0xFF03DAC6);
  static const Color onTertiary = Color(0xFF000000);
  
  // Error Colors
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);
  
  // Surface Colors
  static const Color surface = Color(0xFFFFFBFE);      // Light Mode
  static const Color surfaceDark = Color(0xFF1C1B1F);  // Dark Mode
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  
  // Outline Colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);
  
  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);
  
  // Status Colors (Semantic Colors)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Elevation Colors (M3)
  static Color getSurfaceElevation(int level) {
    return Color.alphaBlend(
      primary.withOpacity(level * 0.05),
      surface,
    );
  }
}
```

### 동적 테마 (Material You 지원)
```dart
// Material 3 테마 설정
ThemeData _buildTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,  // Material 3 활성화
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
    ),
    // 동적 컬러 지원 (Android 12+)
    colorSchemeSeed: AppColors.seedColor,
    
    // 타이포그래피
    textTheme: _buildTextTheme(),
    
    // 컴포넌트 테마
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    
    // 카드 테마 (둥근 모서리 증가)
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // M3: 더 둥근 모서리
      ),
      elevation: 1,
      surfaceTintColor: AppColors.primary,
    ),
    
    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // M3 둥근 모서리
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // M3 둥근 모서리
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // FAB 테마
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
    ),
  );
}

// 다크 모드 테마
ThemeData _buildDarkTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
    ),
    // ... (동일한 구조로 다크 모드 적용)
  );
}
```

### 타이포그래피 (Material Design 3)
M3의 새로운 타이포그래피 시스템을 적용합니다.

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// M3 Text Theme
TextTheme _buildTextTheme() {
  return GoogleFonts.notoSansTextTheme(
    TextTheme(
      // Display Styles (큰 제목)
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      
      // Headline Styles (섹션 제목)
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      ),
      
      // Title Styles (카드 제목)
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      
      // Body Styles (본문)
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      
      // Label Styles (라벨)
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    ),
  );
}
```

**타이포그래피 특징:**
- **Noto Sans** 기본 폰트
- **더 자연스러운 줄 간격** (M3 개선 사항)
- **둥근 숫자** (Lining Numbers)
- **접근성 향상** (읽기 쉬운 크기와 간격)

### 간격 시스템 (Material Design 3)
M3의 8dp 그리드 시스템을 따릅니다.

```dart
class AppSpacing {
  // 8dp 그리드 기반 간격
  static const double xs = 4.0;    // 0.5 × 8
  static const double sm = 8.0;   // 1 × 8
  static const double md = 16.0;  // 2 × 8
  static const double lg = 24.0;  // 3 × 8
  static const double xl = 32.0;  // 4 × 8
  static const double xxl = 48.0; // 6 × 8
  static const double xxxl = 64.0; // 8 × 8
  
  // 컴포넌트 패딩
  static const double componentPadding = md;  // 16dp
  static const double screenPadding = lg;     // 24dp
  static const double cardPadding = md;       // 16dp
  
  // 컴포넌트 간격
  static const double componentGap = sm;     // 8dp
  static const double sectionGap = lg;       // 24dp
  
  // 터치 타겟 (최소 48dp)
  static const double minTouchTarget = 48.0;
  
  // 최소 터치 마진
  static const double minTouchMargin = sm;   // 8dp
}
```

### 모서리 반경 (M3)
```dart
class AppRadius {
  // M3 둥근 모서리 시스템
  static const double xs = 4.0;    // 작은 컴포넌트 (Chip, Badge)
  static const double sm = 8.0;    // 작은 요소 (Button)
  static const double md = 12.0;   // 중간 요소 (Card)
  static const double lg = 16.0;   // 큰 요소 (Sheet, Dialog)
  static const double xl = 24.0;   // 매우 큰 요소 (Modal)
  
  // 컴포넌트별 반경
  static const double buttonRadius = sm;   // 8dp
  static const double cardRadius = lg;    // 16dp
  static const double inputRadius = md;    // 12dp
  static const double fabRadius = lg;     // 16dp
  static const double chipRadius = xl;    // 24dp
  static const double sheetRadius = xl;   // 24dp
}
```

### 아이콘 시스템
- **Material Icons** 기본 사용
- **Custom SVG** (필요시)

---

## 📱 화면 구성

### 1. 인증 화면 (Authentication)

#### 로그인 화면
```dart
LoginPage:
  Scaffold
    appBar: AppBar(title: "신혼부부 가계부")
    body: Column
      - Logo
      - EmailTextField
      - PasswordTextField
      - LoginButton
      - Row(회원가입, 비밀번호 찾기)
```

**구현 예시**:
```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신혼부부 가계부'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 로고
            Icon(Icons.home, size: 80, color: AppColors.primary),
            SizedBox(height: AppSpacing.xl),
            
            // 이메일 입력
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            
            // 비밀번호 입력
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('로그인'),
            ),
            SizedBox(height: AppSpacing.md),
            
            // 회원가입/비밀번호 찾기
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text('회원가입'),
                ),
                Text(' | '),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot'),
                  child: Text('비밀번호 찾기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 2. 대시보드 화면 (Dashboard)

#### 대시보드 레이아웃
```dart
DashboardPage:
  Scaffold
    appBar: AppBar(title: "2025.10", actions: [ProfileButton])
    body: RefreshIndicator
      - MonthSelector
      - SummaryCards (수입/지출)
      - RecentTransactions List
      - CategoryBreakdown
    floatingActionButton: QuickAddFAB
    bottomNavigationBar: BottomNavBar
```

**구현 예시**:
```dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2025.10'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            // 월 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Text('2025년 10월', style: AppTextStyles.headlineMedium),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            
            // 요약 카드
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: '수입',
                    amount: 1000000,
                    color: AppColors.success,
                    icon: Icons.trending_up,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _SummaryCard(
                    title: '지출',
                    amount: 800000,
                    color: AppColors.error,
                    icon: Icons.trending_down,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            
            // 최근 거래
            Text('최근 거래', style: AppTextStyles.titleLarge),
            SizedBox(height: AppSpacing.md),
            ..._buildRecentTransactions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAddModal(context),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add),
        label: Text('거래 입력'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: '거래내역'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }
}
```

---

### 3. 거래 입력 모달 (Quick Add)

```dart
class QuickAddModal extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 핸들바
              Container(
                margin: EdgeInsets.vertical(12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 헤더
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('거래 입력', style: AppTextStyles.headlineMedium),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // 내용
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(AppSpacing.md),
                  children: [
                    // 거래 유형
                    SegmentedButton(
                      segments: [
                        ButtonSegment(value: 'income', label: Text('수입')),
                        ButtonSegment(value: 'expense', label: Text('지출')),
                      ],
                      selected: {'expense'},
                    ),
                    SizedBox(height: AppSpacing.xl),
                    
                    // 금액
                    Text('금액', style: AppTextStyles.titleLarge),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '50,000',
                        suffixText: '원',
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    
                    // 카테고리
                    Text('카테고리', style: AppTextStyles.titleLarge),
                    SizedBox(height: AppSpacing.md),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _CategoryChip(category: categories[index]);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    
                    // 날짜
                    ListTile(
                      title: Text('날짜'),
                      subtitle: Text('2025.10.27'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: AppSpacing.md),
                    
                    // 메모
                    TextField(
                      decoration: InputDecoration(
                        labelText: '메모',
                        hintText: '입력하세요 (선택)',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    
                    // 저장 버튼
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('저장하기'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

### 4. 거래 내역 화면

```dart
class TransactionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('거래 내역'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction.categoryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category,
                color: transaction.categoryColor,
              ),
            ),
            title: Text(transaction.title),
            subtitle: Text('${transaction.category} | ${transaction.date}'),
            trailing: Text(
              '${transaction.amount}원',
              style: TextStyle(
                color: transaction.type == 'expense' 
                    ? AppColors.error 
                    : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _showTransactionDetail(context, transaction),
          );
        },
      ),
    );
  }
}
```

---

## 🎯 애니메이션

### 화면 전환
```dart
// 페이지 전환 애니메이션
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
);
```

### 로딩 애니메이션
```dart
// Shimmer Effect
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    height: 100,
    width: double.infinity,
    color: Colors.white,
  ),
);
```

---

## ✅ 확인 필요 사항

**Flutter로 변경된 주요 사항:**
1. ✅ BLoC 패턴 사용 (상태 관리)
2. ✅ Hive 로컬 DB (오프라인 지원)
3. ✅ Dio HTTP 클라이언트
4. ✅ Material Design 3
5. ✅ fl_chart 차트 라이브러리

**변경된 UI/UX:**
- Kotlin Compose → Flutter Widgets
- Room DB → Hive DB
- Retrofit → Dio
- Koin → Provider/GetIt

확인 부탁드립니다! 🎉


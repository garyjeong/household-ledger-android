# 📱 Flutter 앱 UI/UX 설계

**프로젝트**: 신혼부부 가계부 Flutter 앱  
**날짜**: 2025년 10월  
**플랫폼**: Flutter (iOS, Android)

---

## 🎨 디자인 시스템

### 컬러 팔레트
```dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF7C3AED);      // 보라색
  static const Color primaryVariant = Color(0xFF6D28D9);
  static const Color onPrimary = Colors.white;

  // Secondary Colors
  static const Color secondary = Color(0xFFEC4899);    // 핑크색
  static const Color onSecondary = Colors.white;

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
}
```

### 타이포그래피
```dart
class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
```

### 간격 시스템
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
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


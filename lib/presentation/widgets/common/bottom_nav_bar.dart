import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        AppRouter.navigate(context, index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: '거래내역',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: '통계',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '내정보',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}


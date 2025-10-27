import 'package:flutter/material.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/transactions/transaction_list_page.dart';
import '../../presentation/pages/statistics/statistics_page.dart';
import '../../presentation/pages/profile/profile_page.dart';

class AppRouter {
  static void navigate(BuildContext context, int index) {
    Widget page;
    
    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const TransactionListPage();
        break;
      case 2:
        page = const StatisticsPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = const DashboardPage();
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}


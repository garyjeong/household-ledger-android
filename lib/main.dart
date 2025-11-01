import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_ledger/core/theme/app_theme.dart';
import 'package:household_ledger/core/utils/dependency_injection.dart';
import 'package:household_ledger/presentation/pages/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DependencyInjection.createAuthBloc()),
        BlocProvider(create: (_) => DependencyInjection.createTransactionBloc()),
        BlocProvider(create: (_) => DependencyInjection.createCategoryBloc()),
        BlocProvider(create: (_) => DependencyInjection.createStatisticsBloc()),
        BlocProvider(create: (_) => DependencyInjection.createGroupBloc()),
        BlocProvider(create: (_) => DependencyInjection.createSettingsBloc()),
        BlocProvider(create: (_) => DependencyInjection.createBudgetBloc()),
        BlocProvider(create: (_) => DependencyInjection.createRecurringRuleBloc()),
        BlocProvider(create: (_) => DependencyInjection.createBalanceBloc()),
      ],
      child: MaterialApp(
        title: '신혼부부 가계부',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginPage(),
      ),
    );
  }
}


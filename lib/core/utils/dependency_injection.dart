import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/datasources/remote/auth_api.dart';
import '../../data/datasources/remote/transaction_api.dart';
import '../../data/datasources/remote/category_api.dart';
import '../../data/datasources/remote/statistics_api.dart';
import '../../data/datasources/remote/balance_api.dart';
import '../../data/datasources/remote/budget_api.dart';
import '../../data/datasources/remote/settings_api.dart';
import '../../data/datasources/remote/recurring_rule_api.dart';
import '../../data/datasources/remote/group_api.dart';
import '../../data/providers/http_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/statistics_repository.dart';
import '../../data/repositories/balance_repository.dart';
import '../../data/repositories/budget_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/recurring_rule_repository.dart';
import '../../data/repositories/group_repository.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/transaction/transaction_bloc.dart';
import '../../presentation/bloc/category/category_bloc.dart';
import '../../presentation/bloc/statistics/statistics_bloc.dart';
import '../../presentation/bloc/group/group_bloc.dart';
import '../../presentation/bloc/settings/settings_bloc.dart';
import '../../presentation/bloc/budget/budget_bloc.dart';
import '../../presentation/bloc/recurring_rule/recurring_rule_bloc.dart';
import '../../presentation/bloc/balance/balance_bloc.dart';

/// 의존성 주입 관리
class DependencyInjection {
  static late SharedPreferences _sharedPreferences;
  static late LocalStorage _localStorage;
  
  // API 클라이언트
  static late Dio _dio;
  static late AuthApi _authApi;
  static late TransactionApi _transactionApi;
  static late CategoryApi _categoryApi;
  static late StatisticsApi _statisticsApi;
  static late BalanceApi _balanceApi;
  static late BudgetApi _budgetApi;
  static late SettingsApi _settingsApi;
  static late RecurringRuleApi _recurringRuleApi;
  static late GroupApi _groupApi;
  
  // Repository
  static late AuthRepository _authRepository;
  static late TransactionRepository _transactionRepository;
  static late CategoryRepository _categoryRepository;
  static late StatisticsRepository _statisticsRepository;
  static late BalanceRepository _balanceRepository;
  static late BudgetRepository _budgetRepository;
  static late SettingsRepository _settingsRepository;
  static late RecurringRuleRepository _recurringRuleRepository;
  static late GroupRepository _groupRepository;

  /// 초기화
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStorage = LocalStorage(_sharedPreferences);
    
    // Dio 인스턴스 생성
    _dio = HttpClientFactory.createDio();
    
    // API 클라이언트 생성
    _authApi = AuthApi(_dio);
    _transactionApi = TransactionApi(_dio);
    _categoryApi = CategoryApi(_dio);
    _statisticsApi = StatisticsApi(_dio);
    _balanceApi = BalanceApi(_dio);
    _budgetApi = BudgetApi(_dio);
    _settingsApi = SettingsApi(_dio);
    _recurringRuleApi = RecurringRuleApi(_dio);
    _groupApi = GroupApi(_dio);
    
    // Repository 생성
    _authRepository = AuthRepository(
      authApi: _authApi,
      localStorage: _localStorage,
    );
    _transactionRepository = TransactionRepository(_transactionApi);
    _categoryRepository = CategoryRepository(_categoryApi);
    _statisticsRepository = StatisticsRepository(_statisticsApi);
    _balanceRepository = BalanceRepository(_balanceApi);
    _budgetRepository = BudgetRepository(_budgetApi);
    _settingsRepository = SettingsRepository(_settingsApi);
    _recurringRuleRepository = RecurringRuleRepository(_recurringRuleApi);
    _groupRepository = GroupRepository(_groupApi);
  }

  /// Repository 인스턴스
  static AuthRepository get authRepository => _authRepository;
  static TransactionRepository get transactionRepository => _transactionRepository;
  static CategoryRepository get categoryRepository => _categoryRepository;
  static StatisticsRepository get statisticsRepository => _statisticsRepository;
  static BalanceRepository get balanceRepository => _balanceRepository;
  static BudgetRepository get budgetRepository => _budgetRepository;
  static SettingsRepository get settingsRepository => _settingsRepository;
  static RecurringRuleRepository get recurringRuleRepository => _recurringRuleRepository;
  static GroupRepository get groupRepository => _groupRepository;
  
  /// Dio 인스턴스 (인터셉터 설정용)
  static Dio get dio => _dio;

  /// BLoC 인스턴스 생성
  static AuthBloc createAuthBloc() {
    return AuthBloc(authRepository: _authRepository);
  }
  
  static TransactionBloc createTransactionBloc() {
    return TransactionBloc(repository: _transactionRepository);
  }
  
  static CategoryBloc createCategoryBloc() {
    return CategoryBloc(repository: _categoryRepository);
  }
  
  static StatisticsBloc createStatisticsBloc() {
    return StatisticsBloc(repository: _statisticsRepository);
  }
  
  static GroupBloc createGroupBloc() {
    return GroupBloc(repository: _groupRepository);
  }
  
  static SettingsBloc createSettingsBloc() {
    return SettingsBloc(repository: _settingsRepository);
  }
  
  static BudgetBloc createBudgetBloc() {
    return BudgetBloc(repository: _budgetRepository);
  }
  
  static RecurringRuleBloc createRecurringRuleBloc() {
    return RecurringRuleBloc(repository: _recurringRuleRepository);
  }
  
  static BalanceBloc createBalanceBloc() {
    return BalanceBloc(repository: _balanceRepository);
  }
}


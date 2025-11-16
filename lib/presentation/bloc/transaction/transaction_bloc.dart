import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/transaction.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc({required TransactionRepository repository})
      : _repository = repository,
        super(TransactionInitial()) {
    
    on<LoadTransactions>(_onLoadTransactions);
    on<CreateTransaction>(_onCreateTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<QuickAddTransaction>(_onQuickAddTransaction);
  }

  /// 거래 목록 조회
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    // loadMore가 true이고 현재 상태가 TransactionsLoaded인 경우, 로딩 상태를 유지하면서 추가 로드
    if (event.loadMore && state is TransactionsLoaded) {
      final currentState = state as TransactionsLoaded;
      if (!currentState.hasMore) {
        return; // 더 불러올 데이터가 없으면 종료
      }
    } else {
      emit(TransactionLoading());
    }
    
    try {
      final result = await _repository.getTransactions(
        type: event.type,
        startDate: event.startDate,
        endDate: event.endDate,
        categoryId: event.categoryId,
        search: event.search,
        offset: event.offset,
        limit: event.limit ?? AppConstants.defaultPageSize,
      );
      
      final transactions = result['transactions'] as List<Transaction>;
      final total = result['total'] as int;
      final offset = result['offset'] as int;
      final limit = result['limit'] as int;
      final hasMore = result['hasMore'] as bool;
      
      // loadMore가 true이면 기존 리스트에 추가
      if (event.loadMore && state is TransactionsLoaded) {
        final currentState = state as TransactionsLoaded;
        final updatedTransactions = [
          ...currentState.transactions,
          ...transactions,
        ];
        emit(TransactionsLoaded(
          transactions: updatedTransactions,
          total: total,
          offset: offset,
          limit: limit,
          hasMore: hasMore,
        ));
      } else {
        emit(TransactionsLoaded(
          transactions: transactions,
          total: total,
          offset: offset,
          limit: limit,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// 거래 생성
  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    try {
      await _repository.createTransaction(event.data);
      
      // 성공 메시지
      emit(TransactionSuccess('거래가 성공적으로 추가되었습니다'));
      
      // 목록 새로고침
      final result = await _repository.getTransactions(
        limit: AppConstants.defaultPageSize,
      );
      emit(TransactionsLoaded(
        transactions: result['transactions'] as List<Transaction>,
        total: result['total'] as int,
        offset: result['offset'] as int,
        limit: result['limit'] as int,
        hasMore: result['hasMore'] as bool,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// 거래 수정
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    try {
      await _repository.updateTransaction(event.id, event.data);
      
      // 성공 메시지
      emit(TransactionSuccess('거래가 성공적으로 수정되었습니다'));
      
      // 목록 새로고침
      final result = await _repository.getTransactions(
        limit: AppConstants.defaultPageSize,
      );
      emit(TransactionsLoaded(
        transactions: result['transactions'] as List<Transaction>,
        total: result['total'] as int,
        offset: result['offset'] as int,
        limit: result['limit'] as int,
        hasMore: result['hasMore'] as bool,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// 거래 삭제
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    try {
      await _repository.deleteTransaction(event.id);
      
      // 성공 메시지
      emit(TransactionSuccess('거래가 성공적으로 삭제되었습니다'));
      
      // 목록 새로고침
      final result = await _repository.getTransactions(
        limit: AppConstants.defaultPageSize,
      );
      emit(TransactionsLoaded(
        transactions: result['transactions'] as List<Transaction>,
        total: result['total'] as int,
        offset: result['offset'] as int,
        limit: result['limit'] as int,
        hasMore: result['hasMore'] as bool,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// 거래 새로고침
  Future<void> _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final result = await _repository.getTransactions(
        limit: AppConstants.defaultPageSize,
      );
      emit(TransactionsLoaded(
        transactions: result['transactions'] as List<Transaction>,
        total: result['total'] as int,
        offset: result['offset'] as int,
        limit: result['limit'] as int,
        hasMore: result['hasMore'] as bool,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// 빠른 거래 추가 (Quick Add)
  Future<void> _onQuickAddTransaction(
    QuickAddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    try {
      await _repository.quickAddTransaction(event.data);
      
      // 성공 메시지
      emit(TransactionSuccess('거래가 성공적으로 추가되었습니다'));
      
      // 목록 새로고침
      final result = await _repository.getTransactions(
        limit: AppConstants.defaultPageSize,
      );
      emit(TransactionsLoaded(
        transactions: result['transactions'] as List<Transaction>,
        total: result['total'] as int,
        offset: result['offset'] as int,
        limit: result['limit'] as int,
        hasMore: result['hasMore'] as bool,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}


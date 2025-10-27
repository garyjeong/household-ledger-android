import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../data/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc({required CategoryRepository repository})
      : _repository = repository,
        super(CategoryInitial()) {
    
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<RefreshCategories>(_onRefreshCategories);
  }

  /// 카테고리 목록 조회
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    try {
      final categories = await _repository.getCategories(type: event.type);
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// 카테고리 생성
  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    try {
      await _repository.createCategory(event.data);
      emit(CategorySuccess('카테고리가 생성되었습니다'));
      
      // 목록 새로고침
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// 카테고리 수정
  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    try {
      await _repository.updateCategory(event.id, event.data);
      emit(CategorySuccess('카테고리가 수정되었습니다'));
      
      // 목록 새로고침
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// 카테고리 삭제
  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    try {
      await _repository.deleteCategory(event.id);
      emit(CategorySuccess('카테고리가 삭제되었습니다'));
      
      // 목록 새로고침
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// 카테고리 새로고침
  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}


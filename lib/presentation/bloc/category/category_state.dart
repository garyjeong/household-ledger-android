import 'package:equatable/equatable.dart';
import '../../../../domain/entities/transaction.dart';

/// 카테고리 관련 상태
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class CategoryInitial extends CategoryState {}

/// 로딩 중
class CategoryLoading extends CategoryState {}

/// 카테고리 목록 로드 성공
class CategoriesLoaded extends CategoryState {
  final List<Category> categories;
  
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// 카테고리 생성/수정/삭제 성공
class CategorySuccess extends CategoryState {
  final String message;
  
  const CategorySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class CategoryError extends CategoryState {
  final String message;
  
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}


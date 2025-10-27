import 'package:equatable/equatable.dart';

/// 카테고리 관련 이벤트
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// 카테고리 목록 조회
class LoadCategories extends CategoryEvent {
  final String? type;
  
  const LoadCategories({this.type});

  @override
  List<Object?> get props => [type];
}

/// 카테고리 생성
class CreateCategory extends CategoryEvent {
  final Map<String, dynamic> data;
  
  const CreateCategory(this.data);

  @override
  List<Object?> get props => [data];
}

/// 카테고리 수정
class UpdateCategory extends CategoryEvent {
  final String id;
  final Map<String, dynamic> data;
  
  const UpdateCategory(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

/// 카테고리 삭제
class DeleteCategory extends CategoryEvent {
  final String id;
  
  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}

/// 카테고리 새로고침
class RefreshCategories extends CategoryEvent {
  const RefreshCategories();
}


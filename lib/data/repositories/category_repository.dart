import '../../domain/entities/transaction.dart';
import '../datasources/remote/category_api.dart';

/// 카테고리 Repository
class CategoryRepository {
  final CategoryApi _api;

  CategoryRepository(this._api);

  /// 카테고리 목록 조회
  Future<List<Category>> getCategories({String? type}) async {
    final response = await _api.getCategories(type: type);

    if (response['categories'] is List) {
      return (response['categories'] as List)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// 카테고리 생성
  Future<Category> createCategory(Map<String, dynamic> data) async {
    final response = await _api.createCategory(data);
    return Category.fromJson(response);
  }

  /// 카테고리 수정
  Future<Category> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await _api.updateCategory(id, data);
    return Category.fromJson(response);
  }

  /// 카테고리 삭제
  Future<void> deleteCategory(String id) async {
    await _api.deleteCategory(id);
  }
}


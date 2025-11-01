import 'package:dio/dio.dart';

/// 그룹 API 클라이언트
class GroupApi {
  final Dio _dio;

  GroupApi(this._dio);

  /// 그룹 목록 조회
  Future<List<dynamic>> getGroups() async {
    try {
      final response = await _dio.get('/groups');
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 생성
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/groups', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 조회
  Future<Map<String, dynamic>> getGroup(int groupId) async {
    try {
      final response = await _dio.get('/groups/$groupId');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 수정
  Future<Map<String, dynamic>> updateGroup(int groupId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/groups/$groupId', data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 삭제
  Future<void> deleteGroup(int groupId) async {
    try {
      await _dio.delete('/groups/$groupId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 초대 코드 생성
  Future<Map<String, dynamic>> generateInviteCode(int groupId) async {
    try {
      final response = await _dio.post('/groups/$groupId/invite');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 참가
  Future<Map<String, dynamic>> joinGroup(String inviteCode) async {
    try {
      final response = await _dio.post('/groups/join', data: {'code': inviteCode});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 그룹 나가기
  Future<void> leaveGroup() async {
    try {
      await _dio.post('/groups/leave');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 에러 처리
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['detail'] != null) {
        return data['detail'] as String;
      }
      return '요청 처리 중 오류가 발생했습니다';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return '서버 연결 시간이 초과되었습니다';
    } else if (error.type == DioExceptionType.connectionError) {
      return '서버에 연결할 수 없습니다';
    }
    return '알 수 없는 오류가 발생했습니다';
  }
}


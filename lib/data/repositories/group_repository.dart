import '../datasources/remote/group_api.dart';

/// 그룹 Repository
class GroupRepository {
  final GroupApi _api;

  GroupRepository(this._api);

  /// 그룹 목록 조회
  Future<List<Map<String, dynamic>>> getGroups() async {
    final response = await _api.getGroups();
    return response.map((item) => item as Map<String, dynamic>).toList();
  }

  /// 그룹 생성
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> data) async {
    return await _api.createGroup(data);
  }

  /// 그룹 조회
  Future<Map<String, dynamic>> getGroup(int groupId) async {
    return await _api.getGroup(groupId);
  }

  /// 그룹 수정
  Future<Map<String, dynamic>> updateGroup(int groupId, Map<String, dynamic> data) async {
    return await _api.updateGroup(groupId, data);
  }

  /// 그룹 삭제
  Future<void> deleteGroup(int groupId) async {
    await _api.deleteGroup(groupId);
  }

  /// 초대 코드 생성
  Future<String> generateInviteCode(int groupId) async {
    final response = await _api.generateInviteCode(groupId);
    return response['code'] as String;
  }

  /// 그룹 참가
  Future<Map<String, dynamic>> joinGroup(String inviteCode) async {
    return await _api.joinGroup(inviteCode);
  }

  /// 그룹 나가기
  Future<void> leaveGroup() async {
    await _api.leaveGroup();
  }
}


import 'package:equatable/equatable.dart';

/// 그룹 관련 이벤트
abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

/// 그룹 목록 조회
class LoadGroups extends GroupEvent {
  const LoadGroups();
}

/// 그룹 생성
class CreateGroupRequested extends GroupEvent {
  final String name;

  const CreateGroupRequested({required this.name});

  @override
  List<Object?> get props => [name];
}

/// 그룹 조회
class LoadGroupRequested extends GroupEvent {
  final int groupId;

  const LoadGroupRequested({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// 그룹 수정
class UpdateGroupRequested extends GroupEvent {
  final int groupId;
  final String name;

  const UpdateGroupRequested({
    required this.groupId,
    required this.name,
  });

  @override
  List<Object?> get props => [groupId, name];
}

/// 그룹 삭제
class DeleteGroupRequested extends GroupEvent {
  final int groupId;

  const DeleteGroupRequested({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// 초대 코드 생성
class GenerateInviteCodeRequested extends GroupEvent {
  final int groupId;

  const GenerateInviteCodeRequested({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// 그룹 참가
class JoinGroupRequested extends GroupEvent {
  final String inviteCode;

  const JoinGroupRequested({required this.inviteCode});

  @override
  List<Object?> get props => [inviteCode];
}

/// 그룹 나가기
class LeaveGroupRequested extends GroupEvent {
  const LeaveGroupRequested();
}


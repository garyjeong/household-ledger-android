import 'package:equatable/equatable.dart';

/// 그룹 관련 상태
abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태
class GroupInitial extends GroupState {}

/// 로딩 중
class GroupLoading extends GroupState {}

/// 그룹 목록 로드됨
class GroupsLoaded extends GroupState {
  final List<Map<String, dynamic>> groups;

  const GroupsLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

/// 그룹 상세 로드됨
class GroupLoaded extends GroupState {
  final Map<String, dynamic> group;

  const GroupLoaded(this.group);

  @override
  List<Object?> get props => [group];
}

/// 초대 코드 생성됨
class InviteCodeGenerated extends GroupState {
  final String inviteCode;

  const InviteCodeGenerated(this.inviteCode);

  @override
  List<Object?> get props => [inviteCode];
}

/// 성공 상태
class GroupSuccess extends GroupState {
  final String message;

  const GroupSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// 에러 상태
class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}


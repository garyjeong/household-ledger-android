import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_event.dart';
import 'group_state.dart';
import '../../../data/repositories/group_repository.dart';

/// 그룹 BLoC
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _repository;

  GroupBloc({required GroupRepository repository})
      : _repository = repository,
        super(GroupInitial()) {
    
    on<LoadGroups>(_onLoadGroups);
    on<CreateGroupRequested>(_onCreateGroup);
    on<LoadGroupRequested>(_onLoadGroup);
    on<UpdateGroupRequested>(_onUpdateGroup);
    on<DeleteGroupRequested>(_onDeleteGroup);
    on<GenerateInviteCodeRequested>(_onGenerateInviteCode);
    on<JoinGroupRequested>(_onJoinGroup);
    on<LeaveGroupRequested>(_onLeaveGroup);
  }

  /// 그룹 목록 조회
  Future<void> _onLoadGroups(
    LoadGroups event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      final groups = await _repository.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 생성
  Future<void> _onCreateGroup(
    CreateGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      await _repository.createGroup({'name': event.name});
      emit(GroupSuccess('그룹이 생성되었습니다'));
      
      // 목록 새로고침
      final groups = await _repository.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 조회
  Future<void> _onLoadGroup(
    LoadGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      final group = await _repository.getGroup(event.groupId);
      emit(GroupLoaded(group));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 수정
  Future<void> _onUpdateGroup(
    UpdateGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      await _repository.updateGroup(event.groupId, {'name': event.name});
      emit(GroupSuccess('그룹 이름이 수정되었습니다'));
      
      // 상세 다시 조회
      final group = await _repository.getGroup(event.groupId);
      emit(GroupLoaded(group));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 삭제
  Future<void> _onDeleteGroup(
    DeleteGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      await _repository.deleteGroup(event.groupId);
      emit(GroupSuccess('그룹이 삭제되었습니다'));
      
      // 목록 새로고침
      final groups = await _repository.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 초대 코드 생성
  Future<void> _onGenerateInviteCode(
    GenerateInviteCodeRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      final code = await _repository.generateInviteCode(event.groupId);
      emit(InviteCodeGenerated(code));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 참가
  Future<void> _onJoinGroup(
    JoinGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      await _repository.joinGroup(event.inviteCode);
      emit(GroupSuccess('그룹에 참가했습니다'));
      
      // 목록 새로고침
      final groups = await _repository.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  /// 그룹 나가기
  Future<void> _onLeaveGroup(
    LeaveGroupRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    
    try {
      await _repository.leaveGroup();
      emit(GroupSuccess('그룹에서 나갔습니다'));
      
      // 목록 새로고침
      final groups = await _repository.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}


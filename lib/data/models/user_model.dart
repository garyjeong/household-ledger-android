import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// User 데이터 모델 (JSON 직렬화용)
class UserModel extends Equatable {
  final int id;
  final String email;
  final String nickname;
  final String? avatarUrl;
  final int? groupId;

  const UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.avatarUrl,
    this.groupId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatar_url'] as String?,
      groupId: json['group_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'avatar_url': avatarUrl,
      'group_id': groupId,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      nickname: nickname,
      avatarUrl: avatarUrl,
      groupId: groupId,
    );
  }

  @override
  List<Object?> get props => [id, email, nickname, avatarUrl, groupId];
}


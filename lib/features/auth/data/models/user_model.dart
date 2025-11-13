import 'package:json_annotation/json_annotation.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'userName')
  final String userName;
  @override
  @JsonKey(name: 'password')
  final String password;
  const UserModel({
    required this.id,
    required this.userName,
    required this.password,
  }) : super(id: id, userName: userName, password: password);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserModelFromJson(json);
    } catch (e) {
      // Fallback for null safety
      return UserModel(
        id: json['id'] as int? ?? 0,
        userName:
            json['userName'] as String? ?? json['user_name'] as String? ?? '',
        password: json['password'] as String? ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      userName: user.userName,
      password: user.password,
    );
  }

  User toEntity() {
    return User(id: id, userName: userName, password: password);
  }
}

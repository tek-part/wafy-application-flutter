import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String userName;
  final String password;

  const User({
    required this.id,
    required this.userName,
    required this.password,
  });

  @override
  List<Object> get props => [id, userName, password];
}



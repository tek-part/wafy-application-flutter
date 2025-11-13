import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';

class GetAllUsers {
  final AuthRepository repository;

  GetAllUsers(this.repository);

  Future<Either<Failure, List<User>>> call({bool isRefresh = false}) async {
    return await repository.getAllUsers(isRefresh: isRefresh);
  }
}



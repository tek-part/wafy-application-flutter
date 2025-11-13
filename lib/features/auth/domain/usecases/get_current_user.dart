import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}



import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logout();
  }
}



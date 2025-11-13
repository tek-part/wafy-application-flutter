import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/entities/company.dart';

abstract class AuthRepository {
  Future<Either<Failure, List<User>>> getAllUsers({bool isRefresh = false});
  Future<Either<Failure, User>> login(String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, Company>> getCompInfo({bool isRefresh = false});
}

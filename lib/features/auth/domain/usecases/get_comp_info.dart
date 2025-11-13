import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/domain/entities/company.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';

class GetCompInfo {
  final AuthRepository repository;

  GetCompInfo(this.repository);

  Future<Either<Failure, Company>> call({bool isRefresh = false}) async {
    return await repository.getCompInfo(isRefresh: isRefresh);
  }
}

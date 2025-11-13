import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/floor_entity.dart';
import '../repositories/home_repository.dart';

class GetFloors {
  final HomeRepository repository;

  GetFloors(this.repository);

  Future<Either<Failure, List<FloorEntity>>> call(int userId) async {
    return await repository.getFloors(userId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_entity.dart';
import '../repositories/home_repository.dart';

class GetTables {
  final HomeRepository repository;

  GetTables(this.repository);

  Future<Either<Failure, List<TableEntity>>> call(int floorId) async {
    return await repository.getTablesByFloorId(floorId);
  }
}

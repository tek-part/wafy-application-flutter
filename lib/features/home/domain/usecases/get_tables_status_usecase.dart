import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_status_entity.dart';
import '../repositories/home_repository.dart';

class GetTablesStatus {
  final HomeRepository repository;

  GetTablesStatus(this.repository);

  Future<Either<Failure, List<TableStatusEntity>>> call(int floorId) async {
    return await repository.getTablesStatusByFloorId(floorId);
  }
}

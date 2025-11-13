import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/floor_entity.dart';
import '../entities/table_entity.dart';
import '../entities/table_status_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<FloorEntity>>> getFloors(int userId);
  Future<Either<Failure, List<TableEntity>>> getTablesByFloorId(int floorId);
  Future<Either<Failure, List<TableStatusEntity>>> getTablesStatusByFloorId(
    int floorId,
  );
}

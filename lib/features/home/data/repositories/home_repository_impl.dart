import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/error/failures.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/entities/table_status_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FloorEntity>>> getFloors(int userId) async {
    try {
      final floorModels = await remoteDataSource.getFloors(userId);
      final floors = floorModels.map((model) => model.toEntity()).toList();
      return Right(floors);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TableEntity>>> getTablesByFloorId(
    int floorId,
  ) async {
    try {
      final tableModels = await remoteDataSource.getTablesByFloorId(floorId);
      final tables = tableModels.map((model) => model.toEntity()).toList();
      return Right(tables);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TableStatusEntity>>> getTablesStatusByFloorId(
    int floorId,
  ) async {
    try {
      final response = await remoteDataSource.getTablesStatusByFloorId(floorId);
      final statusEntities = response.data
          .map(
            (model) => TableStatusEntity(
              tableId: model.tableId,
              status: model.status,
              statusName: model.statusName,
              totalInvoice: model.totalInvoice,
              color: model.color,
            ),
          )
          .toList();
      return Right(statusEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }
}

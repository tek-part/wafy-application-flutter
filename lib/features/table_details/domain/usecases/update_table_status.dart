import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../repositories/table_details_repository.dart';

class UpdateTableStatus {
  final TableDetailsRepository repository;

  UpdateTableStatus(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required int rstableId,
    required int status,
  }) async {
    return await repository.updateTableStatus(
      rstableId: rstableId,
      status: status,
    );
  }
}


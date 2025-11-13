import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';
import '../repositories/table_details_repository.dart';

class GetTableDetails {
  final TableDetailsRepository repository;

  GetTableDetails(this.repository);

  Future<Either<Failure, TableEntity>> call(int tableId) async {
    // This will be implemented in the repository
    // For now, we'll return a placeholder
    throw UnimplementedError('GetTableDetails not yet implemented');
  }
}


import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_invoice.dart';
import '../repositories/table_details_repository.dart';

class GetTableInvoice {
  final TableDetailsRepository repository;

  GetTableInvoice(this.repository);

  Future<Either<Failure, TableInvoice>> call(int tableId) async {
    return await repository.getTableInvoice(tableId);
  }
}


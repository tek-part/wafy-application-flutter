import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../repositories/table_details_repository.dart';

class GetLastInvoiceByTableId {
  final TableDetailsRepository repository;

  GetLastInvoiceByTableId(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(int rstableId) async {
    return await repository.getLastInvoiceByTableId(rstableId);
  }
}


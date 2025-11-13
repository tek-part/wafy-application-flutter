import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/invoice_detail.dart';
import '../repositories/table_details_repository.dart';

class CreateInvoice {
  final TableDetailsRepository repository;

  CreateInvoice(this.repository);

  Future<Either<Failure, int>> call({
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  }) async {
    return await repository.createInvoice(
      rstableId: rstableId,
      userId: userId,
      details: details,
    );
  }
}


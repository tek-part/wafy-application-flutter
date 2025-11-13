import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/invoice_detail.dart';
import '../repositories/table_details_repository.dart';

class UpdateInvoice {
  final TableDetailsRepository repository;

  UpdateInvoice(this.repository);

  Future<Either<Failure, int>> call({
    required int invoiceId,
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  }) async {
    return await repository.updateInvoice(
      invoiceId: invoiceId,
      rstableId: rstableId,
      userId: userId,
      details: details,
    );
  }
}


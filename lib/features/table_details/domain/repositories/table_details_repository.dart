import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_order_item.dart';
import '../entities/table_invoice.dart';
import '../entities/invoice_detail.dart';

abstract class TableDetailsRepository {
  Future<Either<Failure, List<TableOrderItem>>> getTableOrders(int tableId);
  Future<Either<Failure, TableInvoice>> getTableInvoice(int tableId);
  Future<Either<Failure, TableOrderItem>> addItemToTable({
    required int tableId,
    required int menuItemId,
    required int quantity,
    String? size,
    String? notes,
  });
  Future<Either<Failure, TableOrderItem>> updateOrderItem({
    required int orderItemId,
    int? quantity,
    String? size,
    String? notes,
  });
  Future<Either<Failure, void>> deleteOrderItem(int orderItemId);
  
  // Invoice methods
  Future<Either<Failure, int>> createInvoice({
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  });
  Future<Either<Failure, Map<String, dynamic>>> getLastInvoiceByTableId(int rstableId);
  Future<Either<Failure, int>> updateInvoice({
    required int invoiceId,
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  });
  Future<Either<Failure, Map<String, dynamic>>> updateTableStatus({
    required int rstableId,
    required int status,
  });
}


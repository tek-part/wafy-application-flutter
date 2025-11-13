import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/error/failures.dart';
import '../../domain/entities/table_order_item.dart';
import '../../domain/entities/table_invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/repositories/table_details_repository.dart';
import '../datasources/table_details_remote_datasource.dart';
import '../models/invoice_request_model.dart';
import '../models/invoice_main_model.dart';
import '../models/invoice_detail_model.dart';

class TableDetailsRepositoryImpl implements TableDetailsRepository {
  final TableDetailsRemoteDataSource remoteDataSource;

  TableDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TableOrderItem>>> getTableOrders(
    int tableId,
  ) async {
    try {
      final orderModels = await remoteDataSource.getTableOrders(tableId);
      final orders = orderModels.map((model) => model.toEntity()).toList();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, TableInvoice>> getTableInvoice(int tableId) async {
    try {
      final invoiceModel = await remoteDataSource.getTableInvoice(tableId);
      return Right(invoiceModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, TableOrderItem>> addItemToTable({
    required int tableId,
    required int menuItemId,
    required int quantity,
    String? size,
    String? notes,
  }) async {
    try {
      final orderModel = await remoteDataSource.addItemToTable(
        tableId: tableId,
        menuItemId: menuItemId,
        quantity: quantity,
        size: size,
        notes: notes,
      );
      return Right(orderModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, TableOrderItem>> updateOrderItem({
    required int orderItemId,
    int? quantity,
    String? size,
    String? notes,
  }) async {
    try {
      final orderModel = await remoteDataSource.updateOrderItem(
        orderItemId: orderItemId,
        quantity: quantity,
        size: size,
        notes: notes,
      );
      return Right(orderModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrderItem(int orderItemId) async {
    try {
      await remoteDataSource.deleteOrderItem(orderItemId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> createInvoice({
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  }) async {
    try {
      final request = InvoiceRequestModel(
        invoiceMain: InvoiceMainModel(
          rstableId: rstableId,
          userId: userId,
        ),
        details: details.map((detail) => InvoiceDetailModel.fromEntity(detail)).toList(),
      );
      
      final response = await remoteDataSource.createInvoice(request);
      return Right(response.invoiceId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLastInvoiceByTableId(int rstableId) async {
    try {
      final response = await remoteDataSource.getLastInvoiceByTableId(rstableId);
      return Right({
        'invoiceMain': response.invoiceMain.toEntity(),
        'details': response.details.map((d) => d.toEntity()).toList(),
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateInvoice({
    required int invoiceId,
    required int rstableId,
    required int userId,
    required List<InvoiceDetail> details,
  }) async {
    try {
      final request = InvoiceRequestModel(
        invoiceMain: InvoiceMainModel(
          invoiceId: invoiceId,
          rstableId: rstableId,
          userId: userId,
        ),
        details: details.map((detail) => InvoiceDetailModel.fromEntity(detail)).toList(),
      );
      
      final response = await remoteDataSource.updateInvoice(invoiceId, request);
      return Right(response.invoiceId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateTableStatus({
    required int rstableId,
    required int status,
  }) async {
    try {
      final response = await remoteDataSource.updateTableStatus(rstableId, status);
      return Right({
        'success': response.success,
        'message': response.message,
        'tableId': response.tableId,
        'tableName': response.tableName,
        'oldStatus': response.oldStatus,
        'oldStatusName': response.oldStatusName,
        'newStatus': response.newStatus,
        'newStatusName': response.newStatusName,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }
}


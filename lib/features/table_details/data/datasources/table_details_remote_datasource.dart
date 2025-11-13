import 'package:dio/dio.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/network/api_client.dart';

import '../models/create_invoice_response_model.dart';
import '../models/invoice_request_model.dart';
import '../models/invoice_response_model.dart';
import '../models/table_invoice_model.dart';
import '../models/table_order_item_model.dart';
import '../models/update_table_status_response_model.dart';

abstract class TableDetailsRemoteDataSource {
  Future<List<TableOrderItemModel>> getTableOrders(int tableId);
  Future<TableInvoiceModel> getTableInvoice(int tableId);
  Future<TableOrderItemModel> addItemToTable({
    required int tableId,
    required int menuItemId,
    required int quantity,
    String? size,
    String? notes,
  });
  Future<TableOrderItemModel> updateOrderItem({
    required int orderItemId,
    int? quantity,
    String? size,
    String? notes,
  });
  Future<void> deleteOrderItem(int orderItemId);

  // Invoice methods
  Future<CreateInvoiceResponseModel> createInvoice(InvoiceRequestModel request);
  Future<InvoiceResponseModel> getLastInvoiceByTableId(int rstableId);
  Future<CreateInvoiceResponseModel> updateInvoice(
    int invoiceId,
    InvoiceRequestModel request,
  );
  Future<UpdateTableStatusResponseModel> updateTableStatus(
    int rstableId,
    int status,
  );
}

class TableDetailsRemoteDataSourceImpl implements TableDetailsRemoteDataSource {
  final ApiClient apiClient;
  final ApiClient? invoiceApiClient; // للـ endpoints التي تحتاج baseUrl2

  TableDetailsRemoteDataSourceImpl({
    required this.apiClient,
    this.invoiceApiClient,
  });

  @override
  Future<List<TableOrderItemModel>> getTableOrders(int tableId) async {
    try {
      // TODO: Implement API call when endpoint is available
      // For now, return empty list
      return [];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<TableInvoiceModel> getTableInvoice(int tableId) async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('getTableInvoice not yet implemented');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<TableOrderItemModel> addItemToTable({
    required int tableId,
    required int menuItemId,
    required int quantity,
    String? size,
    String? notes,
  }) async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('addItemToTable not yet implemented');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<TableOrderItemModel> updateOrderItem({
    required int orderItemId,
    int? quantity,
    String? size,
    String? notes,
  }) async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('updateOrderItem not yet implemented');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> deleteOrderItem(int orderItemId) async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('deleteOrderItem not yet implemented');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<CreateInvoiceResponseModel> createInvoice(
    InvoiceRequestModel request,
  ) async {
    try {
      final client = invoiceApiClient ?? apiClient;
      final response = await client.createInvoice(request);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<InvoiceResponseModel> getLastInvoiceByTableId(int rstableId) async {
    try {
      final client = invoiceApiClient ?? apiClient;
      final response = await client.getLastInvoiceByTableId(rstableId);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<CreateInvoiceResponseModel> updateInvoice(
    int invoiceId,
    InvoiceRequestModel request,
  ) async {
    try {
      final client = invoiceApiClient ?? apiClient;
      final response = await client.updateInvoice(invoiceId, request);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<UpdateTableStatusResponseModel> updateTableStatus(
    int rstableId,
    int status,
  ) async {
    try {
      final client = invoiceApiClient ?? apiClient;
      final response = await client.updateTableStatus(
        rstableId,
        {'status': status},
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        throw ServerException('خطأ في الخادم: ${e.message}');
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }
}

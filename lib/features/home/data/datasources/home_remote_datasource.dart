import 'package:dio/dio.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/network/api_client.dart';
import '../models/floor_model.dart';
import '../models/table_model.dart';
import '../models/table_status_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<FloorModel>> getFloors(int userId);
  Future<List<TableModel>> getTablesByFloorId(int floorId);
  Future<TableStatusResponseModel> getTablesStatusByFloorId(int floorId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FloorModel>> getFloors(int userId) async {
    try {
      final floors = await apiClient.getFloors(userId);
      return floors;
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
  Future<List<TableModel>> getTablesByFloorId(int floorId) async {
    try {
      final tables = await apiClient.getTablesByFloorId(floorId);
      return tables;
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
  Future<TableStatusResponseModel> getTablesStatusByFloorId(int floorId) async {
    try {
      final response = await apiClient.getTablesStatusByFloorId(floorId);
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

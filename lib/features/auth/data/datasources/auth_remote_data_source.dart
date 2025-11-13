import 'package:dio/dio.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/error/error_utils.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/auth/data/models/user_model.dart';
import 'package:wafy/features/auth/data/models/company_model.dart';

abstract class AuthRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<CompanyModel> getCompInfo();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await apiClient.getUsers();
      return users;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        final errorMessage = extractErrorMessage(e);
        throw ServerException(errorMessage);
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<CompanyModel> getCompInfo() async {
    try {
      final companies = await apiClient.getCompInfo();
      return companies.first; // Get the first company from the list
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException('انتهت مهلة الاتصال');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('الخادم غير متاح');
      } else {
        final errorMessage = extractErrorMessage(e);
        throw ServerException(errorMessage);
      }
    } catch (e) {
      throw ServerException('خطأ غير متوقع: $e');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/menu/data/models/menu_category_model.dart';
import 'package:wafy/features/menu/data/models/menu_item_model.dart';
import 'package:wafy/features/menu/data/models/item_size_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuCategoryModel>> getMenuCategories();
  Future<List<MenuItemModel>> getMenuItems(int categoryId);
  Future<List<ItemSizeModel>> getItemSizes(int itemId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final ApiClient apiClient;

  MenuRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MenuCategoryModel>> getMenuCategories() async {
    try {
      final categories = await apiClient.getGroups();
      return categories;
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
  Future<List<MenuItemModel>> getMenuItems(int categoryId) async {
    try {
      final items = await apiClient.getItemsByGroup(categoryId);
      return items;
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
  Future<List<ItemSizeModel>> getItemSizes(int itemId) async {
    try {
      final sizes = await apiClient.getItemSizes(itemId);
      return sizes;
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

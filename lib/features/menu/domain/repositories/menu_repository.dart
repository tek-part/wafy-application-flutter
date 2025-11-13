import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/entities/item_size.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<MenuCategory>>> getMenuCategories({
    bool isRefresh = false,
  });
  Future<Either<Failure, List<MenuItem>>> getMenuItems(
    int categoryId, {
    bool isRefresh = false,
  });
  Future<Either<Failure, List<ItemSize>>> getItemSizes(
    int itemId, {
    bool isRefresh = false,
  });
  Future<Either<Failure, String>> getMenuItemName(int itemId);
  Future<Either<Failure, Unit>> preloadMenuData({
    void Function(double progress, String message)? onProgress,
  });
  Future<Either<Failure, Unit>> refreshMenuData();
  Future<bool> hasCachedMenuData();
}

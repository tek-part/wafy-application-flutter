import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/features/menu/data/models/menu_category_model.dart';
import 'package:wafy/features/menu/data/models/menu_item_model.dart';
import 'package:wafy/features/menu/data/models/item_size_model.dart';

abstract class MenuLocalDataSource {
  Future<List<MenuCategoryModel>> getCachedMenuCategories();
  Future<void> cacheMenuCategories(List<MenuCategoryModel> categories);
  Future<List<MenuItemModel>> getCachedMenuItems(int categoryId);
  Future<void> cacheMenuItems(int categoryId, List<MenuItemModel> items);
  Future<List<ItemSizeModel>> getCachedItemSizes(int itemId);
  Future<void> cacheItemSizes(int itemId, List<ItemSizeModel> sizes);
  Future<void> clearMenuData();
  Future<bool> hasCachedMenuData();
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box menuBox;

  MenuLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.menuBox,
  });

  // دالة مساعدة لتحويل Map<dynamic, dynamic> إلى Map<String, dynamic>
  Map<String, dynamic> _convertToMapStringDynamic(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json;
    }
    if (json is Map) {
      return Map<String, dynamic>.from(json);
    }
    throw Exception('Cannot convert to Map<String, dynamic>');
  }

  @override
  Future<List<MenuCategoryModel>> getCachedMenuCategories() async {
    try {
      final categoriesJson = menuBox.get('menu_categories');
      if (categoriesJson == null) {
        throw const CacheException('لا توجد فئات محفوظة محلياً');
      }

      final List<dynamic> categoriesList = categoriesJson as List<dynamic>;
      return categoriesList
          .map(
            (json) => MenuCategoryModel.fromJson(_convertToMapStringDynamic(json)),
          )
          .toList();
    } catch (e) {
      throw CacheException('خطأ في جلب الفئات المحفوظة: $e');
    }
  }

  @override
  Future<void> cacheMenuCategories(List<MenuCategoryModel> categories) async {
    try {
      final categoriesJson = categories
          .map((category) => category.toJson())
          .toList();
      await menuBox.put('menu_categories', categoriesJson);
    } catch (e) {
      throw CacheException('خطأ في حفظ الفئات: $e');
    }
  }

  @override
  Future<List<MenuItemModel>> getCachedMenuItems(int categoryId) async {
    try {
      final cacheKey = 'menu_items_$categoryId';
      print('📦 [LocalDataSource] البحث عن العناصر في الكاش بالمفتاح: $cacheKey');
      final itemsJson = menuBox.get(cacheKey);
      if (itemsJson == null) {
        print('❌ [LocalDataSource] لا توجد عناصر محفوظة في الكاش للمفتاح: $cacheKey');
        throw const CacheException('لا توجد عناصر محفوظة محلياً لهذه الفئة');
      }

      print('✅ [LocalDataSource] تم العثور على بيانات في الكاش للمفتاح: $cacheKey');
      final List<dynamic> itemsList = itemsJson as List<dynamic>;
      print('📊 [LocalDataSource] عدد العناصر في الكاش: ${itemsList.length}');
      final result = itemsList
          .map((json) => MenuItemModel.fromJson(_convertToMapStringDynamic(json)))
          .toList();
      print('✅ [LocalDataSource] تم تحويل ${result.length} عنصر من JSON بنجاح');
      return result;
    } catch (e) {
      print('❌ [LocalDataSource] خطأ في جلب العناصر المحفوظة: $e');
      throw CacheException('خطأ في جلب العناصر المحفوظة: $e');
    }
  }

  @override
  Future<void> cacheMenuItems(int categoryId, List<MenuItemModel> items) async {
    try {
      final cacheKey = 'menu_items_$categoryId';
      print('💾 [LocalDataSource] بدء حفظ ${items.length} عنصر في الكاش للمفتاح: $cacheKey');
      final itemsJson = items.map((item) => item.toJson()).toList();
      print('📝 [LocalDataSource] تم تحويل ${itemsJson.length} عنصر إلى JSON');
      await menuBox.put(cacheKey, itemsJson);
      print('✅ [LocalDataSource] تم حفظ العناصر في الكاش بنجاح للمفتاح: $cacheKey');
      
      // التحقق من أن البيانات تم حفظها بشكل صحيح
      final verifyData = menuBox.get(cacheKey);
      if (verifyData != null) {
        print('✅ [LocalDataSource] تم التحقق من حفظ البيانات: ${(verifyData as List).length} عنصر');
      } else {
        print('❌ [LocalDataSource] تحذير: البيانات غير موجودة بعد الحفظ!');
      }
    } catch (e) {
      print('❌ [LocalDataSource] خطأ في حفظ العناصر: $e');
      throw CacheException('خطأ في حفظ العناصر: $e');
    }
  }

  @override
  Future<List<ItemSizeModel>> getCachedItemSizes(int itemId) async {
    try {
      final sizesJson = menuBox.get('item_sizes_$itemId');
      if (sizesJson == null) {
        throw const CacheException('لا توجد مقاسات محفوظة محلياً لهذا العنصر');
      }

      final List<dynamic> sizesList = sizesJson as List<dynamic>;
      return sizesList
          .map((json) => ItemSizeModel.fromJson(_convertToMapStringDynamic(json)))
          .toList();
    } catch (e) {
      throw CacheException('خطأ في جلب المقاسات المحفوظة: $e');
    }
  }

  @override
  Future<void> cacheItemSizes(int itemId, List<ItemSizeModel> sizes) async {
    try {
      final sizesJson = sizes.map((size) => size.toJson()).toList();
      await menuBox.put('item_sizes_$itemId', sizesJson);
    } catch (e) {
      throw CacheException('خطأ في حفظ المقاسات: $e');
    }
  }

  @override
  Future<void> clearMenuData() async {
    try {
      await menuBox.clear();
    } catch (e) {
      throw CacheException('خطأ في مسح البيانات: $e');
    }
  }

  @override
  Future<bool> hasCachedMenuData() async {
    try {
      // التحقق من وجود الفئات في الكاش
      final categoriesJson = menuBox.get('menu_categories');
      if (categoriesJson == null) {
        print('📦 [LocalDataSource] لا توجد فئات في الكاش');
        return false;
      }

      final List<dynamic> categoriesList = categoriesJson as List<dynamic>;
      if (categoriesList.isEmpty) {
        print('📦 [LocalDataSource] الفئات في الكاش فارغة');
        return false;
      }

      // التحقق من وجود عناصر لأول فئة على الأقل
      try {
        // محاولة جلب أول فئة (بدون تحويل كامل، فقط التحقق من وجود البيانات)
        final firstCategoryJson = categoriesList[0] as Map;
        final firstCategoryId = firstCategoryJson['id'] as int?;
        
        if (firstCategoryId == null) {
          print('📦 [LocalDataSource] لا يمكن تحديد ID للفئة الأولى');
          return false;
        }

        final itemsJson = menuBox.get('menu_items_$firstCategoryId');
        if (itemsJson == null) {
          print('📦 [LocalDataSource] لا توجد عناصر للفئة الأولى في الكاش');
          return false;
        }

        final List<dynamic> itemsList = itemsJson as List<dynamic>;
        if (itemsList.isEmpty) {
          print('📦 [LocalDataSource] العناصر للفئة الأولى فارغة');
          return false;
        }

        print('✅ [LocalDataSource] تم العثور على بيانات في الكاش: ${categoriesList.length} فئة و ${itemsList.length} عنصر للفئة الأولى');
        return true;
      } catch (e) {
        print('❌ [LocalDataSource] خطأ في التحقق من العناصر: $e');
        return false;
      }
    } catch (e) {
      print('❌ [LocalDataSource] خطأ في التحقق من الكاش: $e');
      return false;
    }
  }
}

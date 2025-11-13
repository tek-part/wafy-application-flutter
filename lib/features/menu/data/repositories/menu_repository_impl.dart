import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:wafy/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/entities/item_size.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;

  MenuRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MenuCategory>>> getMenuCategories({
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        final categoryModels = await remoteDataSource.getMenuCategories();
        final categories = categoryModels
            .map((model) => model.toEntity())
            .toList();
        await localDataSource.cacheMenuCategories(categoryModels);
        return Right(categories);
      } else {
        // جلب الفئات من الـ cache أولاً
        try {
          final cachedCategories = await localDataSource
              .getCachedMenuCategories();
          return Right(
            cachedCategories.map((model) => model.toEntity()).toList(),
          );
        } on CacheException {
          // إذا لم توجد بيانات في الـ cache، جلب من API
          final categoryModels = await remoteDataSource.getMenuCategories();
          final categories = categoryModels
              .map((model) => model.toEntity())
              .toList();

          // حفظ الفئات في الـ cache
          await localDataSource.cacheMenuCategories(categoryModels);

          return Right(categories);
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems(
    int categoryId, {
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        print('🔄 [MenuRepository] جلب العناصر من الخادم للفئة: $categoryId');
        final itemModels = await remoteDataSource.getMenuItems(categoryId);
        final items = itemModels.map((model) => model.toEntity()).toList();
        print(
          '💾 [MenuRepository] حفظ ${itemModels.length} عنصر في الكاش للفئة: $categoryId',
        );
        await localDataSource.cacheMenuItems(categoryId, itemModels);
        print(
          '✅ [MenuRepository] تم حفظ العناصر في الكاش بنجاح للفئة: $categoryId',
        );
        return Right(items);
      } else {
        // جلب العناصر من الـ cache أولاً
        try {
          print(
            '🔍 [MenuRepository] محاولة جلب العناصر من الكاش للفئة: $categoryId',
          );
          final cachedItems = await localDataSource.getCachedMenuItems(
            categoryId,
          );
          print(
            '✅ [MenuRepository] تم جلب ${cachedItems.length} عنصر من الكاش للفئة: $categoryId',
          );
          return Right(cachedItems.map((model) => model.toEntity()).toList());
        } on CacheException catch (e) {
          print(
            '❌ [MenuRepository] الكاش فارغ للفئة $categoryId: ${e.message}',
          );
          print('🌐 [MenuRepository] جلب العناصر من الخادم للفئة: $categoryId');
          // إذا لم توجد بيانات في الـ cache، جلب من API
          final itemModels = await remoteDataSource.getMenuItems(categoryId);
          final items = itemModels.map((model) => model.toEntity()).toList();

          // حفظ العناصر في الـ cache
          print(
            '💾 [MenuRepository] حفظ ${itemModels.length} عنصر في الكاش للفئة: $categoryId',
          );
          await localDataSource.cacheMenuItems(categoryId, itemModels);
          print(
            '✅ [MenuRepository] تم حفظ العناصر في الكاش بنجاح للفئة: $categoryId',
          );

          return Right(items);
        }
      }
    } on ServerException catch (e) {
      print('❌ [MenuRepository] خطأ في الخادم: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      print('❌ [MenuRepository] خطأ في الشبكة: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      print('❌ [MenuRepository] خطأ غير متوقع: $e');
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ItemSize>>> getItemSizes(
    int itemId, {
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        final sizeModels = await remoteDataSource.getItemSizes(itemId);
        final sizes = sizeModels.map((model) => model.toEntity()).toList();
        await localDataSource.cacheItemSizes(itemId, sizeModels);
        return Right(sizes);
      } else {
        // جلب المقاسات من الـ cache أولاً
        try {
          final cachedSizes = await localDataSource.getCachedItemSizes(itemId);
          return Right(cachedSizes.map((model) => model.toEntity()).toList());
        } on CacheException {
          // إذا لم توجد بيانات في الـ cache، جلب من API
          final sizeModels = await remoteDataSource.getItemSizes(itemId);
          final sizes = sizeModels.map((model) => model.toEntity()).toList();

          // حفظ المقاسات في الـ cache
          await localDataSource.cacheItemSizes(itemId, sizeModels);

          return Right(sizes);
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getMenuItemName(int itemId) async {
    try {
      // جلب جميع الفئات من الـ cache
      final categoriesResult = await getMenuCategories();
      return await categoriesResult.fold((failure) => Left(failure), (
        categories,
      ) async {
        // البحث عن العنصر في جميع الفئات
        for (final category in categories) {
          final itemsResult = await getMenuItems(category.id);
          final itemsEither = itemsResult.fold(
            (failure) => Left<Failure, List<MenuItem>>(failure),
            (items) => Right<Failure, List<MenuItem>>(items),
          );
          final items = itemsEither.fold(
            (failure) => <MenuItem>[],
            (items) => items,
          );
          final item = items.firstWhere(
            (item) => item.id == itemId,
            orElse: () => throw Exception('العنصر غير موجود'),
          );
          if (item.id == itemId) {
            return Right(item.nameAr);
          }
        }
        return Left(ServerFailure('العنصر غير موجود'));
      });
    } catch (e) {
      return Left(ServerFailure('خطأ في جلب اسم العنصر: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> preloadMenuData({
    void Function(double progress, String message)? onProgress,
  }) async {
    try {
      print('🚀 [PreloadMenuData] بدء تحميل جميع بيانات القائمة...');
      // جلب جميع الفئات
      onProgress?.call(0.0, 'جاري تحميل الفئات...');
      print('📋 [PreloadMenuData] جلب الفئات من الخادم...');
      final categoriesResult = await getMenuCategories(isRefresh: true);
      return await categoriesResult.fold((failure) => Left(failure), (
        categories,
      ) async {
        print('✅ [PreloadMenuData] تم جلب ${categories.length} فئة');
        final totalCategories = categories.length;
        final totalSteps = totalCategories * 2; // categories + items
        int currentStep = 0;

        // جلب جميع العناصر من جميع الفئات
        print('📦 [PreloadMenuData] بدء تحميل العناصر لجميع الفئات...');
        for (int i = 0; i < categories.length; i++) {
          final category = categories[i];
          currentStep++;
          final progress = (currentStep / totalSteps) * 0.5; // 50% للعناصر
          onProgress?.call(
            progress,
            'جاري تحميل عناصر الفئة ${i + 1} من $totalCategories...',
          );
          print(
            '📥 [PreloadMenuData] تحميل عناصر الفئة ${i + 1}/$totalCategories (ID: ${category.id})',
          );
          await getMenuItems(category.id, isRefresh: true);
          print('✅ [PreloadMenuData] تم تحميل وحفظ عناصر الفئة ${category.id}');
        }

        // جلب جميع المقاسات لجميع العناصر
        int totalItems = 0;
        for (final category in categories) {
          final itemsResult = await getMenuItems(category.id);
          await itemsResult.fold((failure) async {}, (items) async {
            totalItems += items.length;
          });
        }

        int itemsProcessed = 0;
        for (int i = 0; i < categories.length; i++) {
          final category = categories[i];
          final itemsResult = await getMenuItems(category.id);
          await itemsResult.fold((failure) async {}, (items) async {
            for (int j = 0; j < items.length; j++) {
              final item = items[j];
              itemsProcessed++;
              final progress =
                  0.5 + (itemsProcessed / totalItems) * 0.5; // 50% للمقاسات
              onProgress?.call(
                progress,
                'جاري تحميل المقاسات... ($itemsProcessed من $totalItems)',
              );
              await getItemSizes(item.id, isRefresh: true);
            }
          });
        }

        onProgress?.call(1.0, 'اكتمل التحميل');
        print('🎉 [PreloadMenuData] اكتمل تحميل جميع بيانات القائمة بنجاح!');
        return const Right(unit);
      });
    } on ServerException catch (e) {
      print('❌ [PreloadMenuData] خطأ في الخادم: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      print('❌ [PreloadMenuData] خطأ في الشبكة: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      print('❌ [PreloadMenuData] خطأ غير متوقع: $e');
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshMenuData() async {
    try {
      await localDataSource.clearMenuData();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<bool> hasCachedMenuData() async {
    try {
      return await localDataSource.hasCachedMenuData();
    } catch (e) {
      print('❌ [MenuRepository] خطأ في التحقق من الكاش: $e');
      return false;
    }
  }
}

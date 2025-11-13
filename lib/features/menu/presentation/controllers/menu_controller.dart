import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/usecases/preload_menu_data.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_categories_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_items_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/menu/presentation/states/menu_categories_state.dart';
import 'package:wafy/features/menu/presentation/states/menu_items_state.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullMenuController extends GetxController {
  final MenuCategoriesController _categoriesController;
  final MenuItemsController _itemsController;
  final PreloadMenuData? _preloadMenuData;
  final MenuRepository? _menuRepository;

  FullMenuController(
    this._categoriesController,
    this._itemsController, {
    PreloadMenuData? preloadMenuData,
    MenuRepository? menuRepository,
  })  : _preloadMenuData = preloadMenuData,
        _menuRepository = menuRepository;

  // Menu mode for controlling behavior
  final Rx<MenuMode> menuMode = MenuMode.view.obs;

  // Selected category index
  final RxInt selectedCategoryIndex = 0.obs;

  // Table ID for addToTable mode
  final RxString tableId = ''.obs;

  // متغير لتتبع ما إذا كانت البيانات تم تحميلها
  bool _isInitialized = false;
  // متغير لتتبع ما إذا كانت البيانات تم تحميلها مسبقاً
  bool _isPreloaded = false;
  // متغير لتتبع ما إذا رفض المستخدم التحميل المسبق
  bool _userRejectedPreload = false;

  // Progress state للـ preload
  final RxDouble preloadProgress = 0.0.obs;
  final RxString preloadMessage = 'جاري تحميل البيانات...'.obs;
  final RxBool isPreloading = false.obs;

  // Getters للوصول إلى state من controllers الفرعية
  MenuCategoriesState get categoriesState => _categoriesController.state;
  MenuItemsState get itemsState => _itemsController.state;

  // Getters للوصول إلى البيانات من state
  List<MenuCategory> get categories {
    return _categoriesController.state.when(
      initial: () => [],
      loading: () => [],
      success: (categories) => categories,
      error: (_) => [],
    );
  }

  List<MenuItem> get items {
    return _itemsController.state.when(
      initial: () => [],
      loading: () => [],
      success: (items) => items,
      error: (_) => [],
    );
  }

  Future<bool> checkCacheData() async {
    final repository = _menuRepository;
    if (repository == null) {
      print('⚠️ [MenuController] MenuRepository غير متاح للتحقق من الكاش');
      return false;
    }
    try {
      final hasCache = await repository.hasCachedMenuData();
      print('🔍 [MenuController] فحص الكاش: ${hasCache ? "موجود" : "فارغ"}');
      return hasCache;
    } catch (e) {
      print('❌ [MenuController] خطأ في فحص الكاش: $e');
      return false;
    }
  }

  void setUserRejectedPreload(bool rejected) {
    _userRejectedPreload = rejected;
    print('📝 [MenuController] تم تعيين _userRejectedPreload = $rejected');
  }

  Future<bool> showCacheEmptyDialog() async {
    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تنبيه',
                style: FontConstants.cairoStyle(
                  fontSize: 20.sp,
                  weight: FontConstants.cairoBold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'قائمة الطعام ليست محفوظة على الجهاز. هل تريد تحميلها الآن أم تريد أن تكمل وتتعامل مع السيرفر؟',
                style: FontConstants.cairoStyle(
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      'نعم',
                      style: FontConstants.cairoStyle(
                        fontSize: 16.sp,
                        weight: FontConstants.cairoSemiBold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(result: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      'لا',
                      style: FontConstants.cairoStyle(
                        fontSize: 16.sp,
                        weight: FontConstants.cairoSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    ) ?? false;
  }

  Future<void> preloadMenuDataWithDialog() async {
    final preloadData = _preloadMenuData;
    if (preloadData == null) {
      Get.snackbar('خطأ', 'لا يمكن تحميل البيانات');
      return;
    }

    // إظهار dialog التحميل
    _showPreloadDialog();

    try {
      final result = await preloadData(
        onProgress: (progress, message) {
          preloadProgress.value = progress;
          preloadMessage.value = message;
        },
      );

      result.fold(
        (failure) {
          Get.back(); // إغلاق dialog
          Get.snackbar('خطأ', failure.message);
        },
        (_) {
          _isPreloaded = true;
          Get.back(); // إغلاق dialog
        },
      );
    } catch (e) {
      Get.back(); // إغلاق dialog
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
    }
  }

  Future<void> initializeData() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // إذا رفض المستخدم التحميل المسبق، جلب من الخادم مباشرة
    if (_userRejectedPreload) {
      print('🔄 [MenuController] المستخدم رفض التحميل المسبق - جلب من الخادم مباشرة');
      await _categoriesController.loadCategories(isRefresh: true);
      final categoriesList = categories;
      if (categoriesList.isNotEmpty) {
        await _itemsController.loadItems(
          categoriesList[0].id,
          isRefresh: true,
        );
        selectedCategoryIndex.value = 0;
      }
      return;
    }

    // محاولة تحميل الفئات من الـ cache أولاً
    await _categoriesController.loadCategories(isRefresh: false);

    // التحقق من وجود البيانات في الـ cache
    final categoriesList = categories;
    bool hasCachedData = categoriesList.isNotEmpty;

    // إذا كانت هناك فئات في الـ cache، تحقق من وجود عناصر للفئة الأولى
    if (hasCachedData && categoriesList.isNotEmpty) {
      try {
        await _itemsController.loadItems(
          categoriesList[0].id,
          isRefresh: false,
        );
        // إذا نجح تحميل العناصر، فهذا يعني أن البيانات موجودة في الـ cache
        _isPreloaded = true;
      } catch (e) {
        // إذا فشل تحميل العناصر، قد لا تكون البيانات موجودة بالكامل
        hasCachedData = false;
      }
    }

    // تحميل جميع البيانات مسبقاً فقط إذا لم تكن موجودة في الـ cache
    final preloadData = _preloadMenuData;
    if (!hasCachedData && !_isPreloaded && preloadData != null) {
      // إظهار dialog التحميل
      _showPreloadDialog();

      try {
        final result = await preloadData(
          onProgress: (progress, message) {
            preloadProgress.value = progress;
            preloadMessage.value = message;
          },
        );

        result.fold(
          (failure) {
            Get.back(); // إغلاق dialog
            Get.snackbar('خطأ', failure.message);
          },
          (_) {
            _isPreloaded = true;
            Get.back(); // إغلاق dialog
          },
        );
      } catch (e) {
        Get.back(); // إغلاق dialog
        Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
      }
    }

    // إذا لم تكن الفئات محملة بعد، قم بتحميلها
    if (categories.isEmpty) {
      // إذا رفض المستخدم التحميل المسبق، جلب من الخادم مباشرة
      await _categoriesController.loadCategories(
        isRefresh: _userRejectedPreload,
      );
    }

    // بعد تحميل الفئات بنجاح، تحميل العناصر للفئة الأولى
    final finalCategoriesList = categories;
    if (finalCategoriesList.isNotEmpty) {
      final firstCategoryId = finalCategoriesList[0].id;
      // إذا رفض المستخدم التحميل المسبق، جلب من الخادم مباشرة
      _itemsController.loadItems(
        firstCategoryId,
        isRefresh: _userRejectedPreload,
      );
      selectedCategoryIndex.value = 0;
    }
  }

  void _showPreloadDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // منع إغلاق dialog
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'جاري تحميل البيانات',
                  style: FontConstants.cairoStyle(
                    fontSize: 18.sp,
                    weight: FontConstants.cairoBold,
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => LinearProgressIndicator(
                    value: preloadProgress.value,
                    minHeight: 8.h,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => Text(
                    '${(preloadProgress.value * 100).toStringAsFixed(0)}%',
                    style: FontConstants.cairoStyle(
                      fontSize: 16.sp,
                      weight: FontConstants.cairoSemiBold,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Text(
                    preloadMessage.value,
                    style: FontConstants.cairoStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void setMenuMode(MenuMode mode) {
    menuMode.value = mode;
  }

  void setTableId(String id) {
    tableId.value = id;
    menuMode.value = MenuMode.addToTable;
  }

  void clearTableId() {
    tableId.value = '';
    menuMode.value = MenuMode.view;
  }

  void changeCategory(int index) {
    print('Changing category to index: $index');
    print('Previous selectedCategoryIndex: ${selectedCategoryIndex.value}');
    selectedCategoryIndex.value = index;
    print('New selectedCategoryIndex: ${selectedCategoryIndex.value}');

    final categoriesList = categories;
    if (categoriesList.isNotEmpty && index < categoriesList.length) {
      final categoryId = categoriesList[index].id;
      print('Loading items for category ID: $categoryId');
      // إذا رفض المستخدم التحميل المسبق، جلب من الخادم مباشرة
      _itemsController.loadItems(
        categoryId,
        isRefresh: _userRejectedPreload,
      );
    }
  }

  Future<void> refreshData() async {
    await _categoriesController.refreshCategories();
    final categoriesList = categories;
    if (categoriesList.isNotEmpty &&
        selectedCategoryIndex.value < categoriesList.length) {
      await _itemsController.refreshItems();
    }
  }

  void clearItems() {
    _itemsController.clearItems();
  }

  void resetPreloadState() {
    _isPreloaded = false;
    preloadProgress.value = 0.0;
    preloadMessage.value = 'جاري تحميل البيانات...';
  }
}

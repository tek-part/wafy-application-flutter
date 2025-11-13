import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/menu/domain/usecases/refresh_menu_data.dart';
import 'package:wafy/features/menu/domain/usecases/preload_menu_data.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';

class SettingsController extends GetxController {
  final RefreshMenuData _refreshMenuData;
  final PreloadMenuData _preloadMenuData;
  final FullMenuController? _menuController;

  SettingsController(
    this._refreshMenuData,
    this._preloadMenuData, {
    FullMenuController? menuController,
  }) : _menuController = menuController;

  // Progress state للـ preload
  final RxDouble preloadProgress = 0.0.obs;
  final RxString preloadMessage = 'جاري تحميل البيانات...'.obs;
  final RxBool isReloading = false.obs;

  Future<void> clearAndReloadMenuData() async {
    // إظهار confirmation dialog
    final shouldProceed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: FontConstants.cairoStyle(
            fontSize: 18.sp,
            weight: FontConstants.cairoBold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف جميع البيانات المحلية وإعادة تحميلها؟',
          style: FontConstants.cairoStyle(
            fontSize: 16.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'إلغاء',
              style: FontConstants.cairoStyle(
                fontSize: 16.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'موافق',
              style: FontConstants.cairoStyle(
                fontSize: 16.sp,
                weight: FontConstants.cairoBold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (shouldProceed != true) return;

    isReloading.value = true;

    try {
      // إظهار progress dialog
      _showPreloadDialog();

      // حذف جميع البيانات المحلية
      final clearResult = await _refreshMenuData();
      await clearResult.fold(
        (failure) {
          Get.back(); // إغلاق dialog
          Get.snackbar('خطأ', failure.message);
          isReloading.value = false;
        },
        (_) async {
          // إعادة تعيين preload state في MenuController
          if (_menuController != null) {
            _menuController.resetPreloadState();
          }

          // إعادة تحميل البيانات مع progress
          final reloadResult = await _preloadMenuData(
            onProgress: (progress, message) {
              preloadProgress.value = progress;
              preloadMessage.value = message;
            },
          );

          await reloadResult.fold(
            (failure) {
              Get.back(); // إغلاق dialog
              Get.snackbar('خطأ', failure.message);
              isReloading.value = false;
            },
            (_) {
              Get.back(); // إغلاق dialog
              Get.snackbar('نجح', 'تم حذف وإعادة تحميل البيانات بنجاح');
              isReloading.value = false;
            },
          );
        },
      );
    } catch (e) {
      Get.back(); // إغلاق dialog
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
      isReloading.value = false;
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
}


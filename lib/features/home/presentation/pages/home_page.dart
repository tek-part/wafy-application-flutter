import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/features/home/presentation/controllers/home_controller.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/features/menu/presentation/pages/menu_page.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/home/presentation/pages/tables_page.dart';
import 'package:wafy/features/oreder/presentation/pages/orders_page.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static bool _hasCheckedCache = false;

  @override
  Widget build(BuildContext context) {
    // إعادة تعيين menuMode إلى view عند العودة للشاشة الرئيسية
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Get.isRegistered<FullMenuController>()) {
        final menuController = Get.find<FullMenuController>();
        // فقط إذا لم يكن في وضع addToTable من صفحة أخرى
        if (menuController.menuMode.value == MenuMode.addToTable &&
            menuController.tableId.value.isEmpty) {
          menuController.clearTableId();
        }

        // فحص الكاش عند فتح HomePage لأول مرة
        if (!_hasCheckedCache) {
          _hasCheckedCache = true;
          final hasCache = await menuController.checkCacheData();

          if (!hasCache) {
            // عرض Dialog للسؤال
            final shouldPreload = await menuController.showCacheEmptyDialog();

            if (shouldPreload) {
              // المستخدم اختار "نعم" - تحميل البيانات
              await menuController.preloadMenuDataWithDialog();
            } else {
              // المستخدم اختار "لا" - تعيين flag للتعامل مع السيرفر مباشرة
              menuController.setUserRejectedPreload(true);
            }
          }
        }
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // عرض dialog تأكيد
        final shouldExit = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              'إغلاق التطبيق',
              style: FontConstants.cairoStyle(
                fontSize: 18.sp,
                weight: FontConstants.cairoBold,
                color: AppColors.primary,
              ),
            ),
            content: Text(
              'هل تريد إغلاق التطبيق؟',
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
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'إغلاق',
                  style: FontConstants.cairoStyle(
                    fontSize: 14.sp,
                    weight: FontConstants.cairoBold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (shouldExit == true) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: const [TablesPage(), MenuPage(), OrdersPage()],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.primary,
            selectedItemColor: AppColors.bottomNavigationBarSelectedItem,
            unselectedItemColor: Colors.white70,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'الطاولات',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIconsDataType.orders_bottom_nav_icon),
                label: 'القائمة',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CustomIconsDataType.tables_bottom_nav_icon),
              //   label: 'الطلبات',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

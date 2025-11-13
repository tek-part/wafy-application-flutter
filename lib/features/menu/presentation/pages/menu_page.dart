import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_body.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_button.dart';
import 'package:wafy/features/menu/presentation/states/menu_categories_state.dart';

class MenuPage extends GetView<FullMenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استقبال arguments وتغيير menuMode إلى addToTable إذا كان tableId موجوداً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = Get.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments.containsKey('tableId')) {
        final tableId = arguments['tableId'];
        if (tableId != null) {
          controller.setTableId(tableId.toString());
        }
      }

      // تحميل البيانات عند فتح الصفحة لأول مرة
      if (controller.categoriesState == const MenuCategoriesState.initial()) {
        controller.initializeData();
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomAppBar(
                title: 'القائمة',
                icon: CustomIconsDataType.orders_bottom_nav_icon,
                onPressed: () {
                  // إعادة تعيين menuMode إلى view عند العودة
                  if (controller.menuMode.value == MenuMode.addToTable) {
                    controller.clearTableId();
                  }
                  Get.back();
                },
              ),
            ),
            SizedBox(
              height: 40.h,
              child: Obx(() {
                return controller.categoriesState.when(
                  initial: () => Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5, // عدد الفئات الوهمية
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CategoryMenuButton(
                          text: "فئة $index",
                          isSelected: false,
                          onPressed: () {},
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 16.w);
                      },
                    ),
                  ),
                  loading: () => Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5, // عدد الفئات الوهمية
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CategoryMenuButton(
                          text: "فئة $index",
                          isSelected: false,
                          onPressed: () {},
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 16.w);
                      },
                    ),
                  ),
                  success: (categories) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: categories.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => CategoryMenuButton(
                            text: categories[index].nameAr,
                            isSelected:
                                controller.selectedCategoryIndex.value == index,
                            onPressed: () {
                              print(
                                'MenuPage: Category button pressed for index: $index',
                              );
                              controller.changeCategory(index);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 16.w);
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                return controller.itemsState.when(
                  initial: () {
                    // عرض skeleton إذا كانت الفئات محملة لكن العناصر لم تُحمّل بعد
                    final categoriesList = controller.categories;
                    if (categoriesList.isEmpty) {
                      return Skeletonizer(
                        enabled: true,
                        child: GridView.builder(
                          padding: EdgeInsets.all(16.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          itemCount: 6, // عدد العناصر الوهمية
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("عنصر $index"),
                                  SizedBox(height: 8.h),
                                  Text("السعر: 1000 د.ع"),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: Text('اختر فئة لعرض العناصر'));
                  },
                  loading: () => Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: 6, // عدد العناصر الوهمية
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("عنصر $index"),
                              SizedBox(height: 8.h),
                              Text("السعر: 1000 د.ع"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  success: (items) {
                    final categoriesList = controller.categories;
                    if (categoriesList.isEmpty) {
                      return const Center(child: Text('لا توجد فئات متاحة'));
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                          child: child,
                        );
                      },
                      child: Obx(
                        () => CategoryMenuBody(
                          key: ValueKey(
                            categoriesList[controller
                                    .selectedCategoryIndex
                                    .value]
                                .id,
                          ),
                          menuItems: items,
                          showAddButton:
                              controller.menuMode.value == MenuMode.addToTable,
                        ),
                      ),
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          message,
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_body.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_button.dart';
import 'package:wafy/features/menu/presentation/states/menu_categories_state.dart';
import 'package:wafy/features/table_details/presentation/controllers/table_details_controller.dart';

class MenuPage extends GetView<FullMenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من وجود arguments قبل الوصول إليها
    final arguments = Get.arguments as Map<String, dynamic>?;
    String? tableId;
    if (arguments != null && arguments.containsKey('tableId')) {
      final tableIdValue = arguments['tableId'];
      // قبول int أو String وتحويله إلى String
      tableId = tableIdValue?.toString();
    }

    // استقبال arguments وتغيير menuMode إلى addToTable إذا كان tableId موجوداً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (arguments != null && arguments.containsKey('tableId')) {
        final tableIdValue = arguments['tableId'];
        if (tableIdValue != null) {
          controller.setTableId(tableIdValue.toString());
        }
      }

      // تحميل البيانات عند فتح الصفحة لأول مرة
      if (controller.categoriesState == const MenuCategoriesState.initial()) {
        controller.initializeData();
      }
    });
    return Scaffold(
      floatingActionButton: Obx(() {
        // إظهار الزر فقط إذا كان menuMode == addToTable وكانت هناك عناصر مضافة
        if (controller.menuMode.value == MenuMode.addToTable ||
            arguments != null && arguments.containsKey('tableId')) {
          // محاولة الوصول إلى TableDetailsController للتحقق من وجود عناصر
          if (Get.isRegistered<TableDetailsController>()) {
            final tableController = Get.find<TableDetailsController>();
            if (tableController.newPendingItems.isNotEmpty) {
              return FloatingActionButton.extended(
                onPressed: () {
                  // الانتقال إلى صفحة table_details مع استبدال الشاشة الحالية
                  final tableIdStr = controller.tableId.value;
                  if (tableIdStr.isNotEmpty) {
                    final tableIdInt = int.tryParse(tableIdStr);
                    if (tableIdInt != null) {
                      Get.offNamed(
                        Routes.tableDetails,
                        arguments: {
                          'tableId': tableIdInt,
                          'tableName': 'طاولة $tableIdStr',
                        },
                      );
                    }
                  }
                },
                backgroundColor: AppColors.primary,
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: Obx(() {
                  if (Get.isRegistered<TableDetailsController>()) {
                    final tableController = Get.find<TableDetailsController>();
                    return Text(
                      'عرض الطلب (${tableController.newPendingItems.length})',
                      style: FontConstants.cairoStyle(
                        fontSize: 14.sp,
                        weight: FontConstants.cairoMedium,
                        color: Colors.white,
                      ),
                    );
                  }
                  return Text(
                    'عرض الطلب',
                    style: FontConstants.cairoStyle(
                      fontSize: 14.sp,
                      weight: FontConstants.cairoMedium,
                      color: Colors.white,
                    ),
                  );
                }),
              );
            }
          }
        }
        return const SizedBox.shrink();
      }),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomAppBar(
                title: 'القائمة',
                showBackButton: tableId != null,
                onPressed: () {
                  if (tableId != null) {
                    controller.setTableId(tableId.toString());
                  }
                  Get.back();
                },
              ),
            ),
            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.filterItems(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث في القائمة...',
                    hintStyle: FontConstants.cairoStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    suffixIcon: Obx(
                      () => controller.isSearching.value
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                controller.clearSearch();
                              },
                            )
                          : SizedBox.shrink(),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 50.h,
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
                        return SizedBox(width: 8.w);
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Text(
                      message,
                      style: FontConstants.cairoStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                      ),
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
                      child: Obx(() {
                        // استخدام filteredItems عند البحث، وإلا استخدام items العادية
                        final itemsToShow = controller.isSearching.value
                            ? controller.filteredItems
                            : items;

                        // إذا كان البحث نشطاً ولا توجد نتائج، عرض رسالة
                        if (controller.isSearching.value &&
                            itemsToShow.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'لا توجد عناصر بهذا الاسم',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 18.sp,
                                    weight: FontConstants.cairoBold,
                                    color: AppColors.grayDarker,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'جرب البحث بكلمة أخرى',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.grayDarker,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return CategoryMenuBody(
                          key: ValueKey(
                            controller.isSearching.value
                                ? 'search_${controller.searchController.text}'
                                : categoriesList[controller
                                          .selectedCategoryIndex
                                          .value]
                                      .id,
                          ),
                          menuItems: itemsToShow,
                          showAddButton: tableId != null,
                        );
                      }),
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
                          style: FontConstants.cairoStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          child: Text(
                            'إعادة المحاولة',
                            style: FontConstants.cairoStyle(
                              fontSize: 14.sp,
                              weight: FontConstants.cairoMedium,
                            ),
                          ),
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

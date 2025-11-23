import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/app_images.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/features/home/presentation/controllers/floors_controller.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/home/presentation/pages/widgets/floors_bar_item.dart';
import 'package:wafy/features/home/presentation/pages/widgets/table_item.dart';

class TablesPage extends GetView<FloorsController> {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tablesController = Get.find<TablesController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomAppBar(
                  title: "الطاوله",
                  hasLogo: true,
                  isHomeScreen: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "اختر الطابق",
                    style: FontConstants.cairoStyle(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      weight: FontConstants.cairoSemiBold,
                    ),
                  ),
                ),
              ),

              // عرض الطوابق
              Obx(() {
                return controller.state.when(
                  initial: () => const SizedBox(),
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: 60.h,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  success: (floors) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: SizedBox(
                      height: 60.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: floors.length,
                        itemBuilder: (context, index) {
                          final floor = floors[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() {
                              final isSelected =
                                  controller.selectedFloorId.value == floor.id;
                              return FloorsBarItem(
                                floor: floor,
                                isSelected: isSelected,
                                onTap: () => controller.selectFloor(floor),
                              );
                            }),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 5.w),
                      ),
                    ),
                  ),
                  error: (message) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: 60.h,
                      child: Center(
                        child: Text(
                          message,
                          style: FontConstants.cairoStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: _buildStatusLegend(
                        'الكل',
                        null,
                        null,
                        onTap: () => tablesController.setStatusFilter(null),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: _buildStatusLegend(
                        'متاح',
                        AppImages.emptyStateCircle,
                        1,
                        onTap: () => tablesController.setStatusFilter(1),
                      ),
                    ),

                    SizedBox(width: 4.w),
                    Flexible(
                      child: _buildStatusLegend(
                        'مشغول',
                        AppImages.workingStateCircle,
                        2,
                        onTap: () => tablesController.setStatusFilter(2),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: _buildStatusLegend(
                        'فاتورة',
                        AppImages.waitingPayStateCircle,
                        3,
                        onTap: () => tablesController.setStatusFilter(3),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // عرض الطاولات
              Obx(() {
                return tablesController.state.when(
                  initial: () =>
                      const Center(child: Text('اختر طابقاً لعرض الطاولات')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (tables) {
                    // تصفية الطاولات حسب الحالة المحددة
                    final filteredTables = tablesController.getFilteredTables();

                    // إذا لم توجد طاولات بعد التصفية وكان هناك طاولات في الأصل، عرض رسالة
                    if (filteredTables.isEmpty && tables.isNotEmpty) {
                      final selectedStatus =
                          tablesController.selectedStatusFilter.value;
                      String statusName = 'المحددة';
                      if (selectedStatus == null) {
                        statusName = 'الكل';
                      } else if (selectedStatus == 1) {
                        statusName = 'متاح';
                      } else if (selectedStatus == 2) {
                        statusName = 'مشغول';
                      } else if (selectedStatus == 3) {
                        statusName = 'فاتورة';
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.table_restaurant_outlined,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'لا توجد طاولات بحالة "$statusName"',
                              style: FontConstants.cairoStyle(
                                fontSize: 18.sp,
                                weight: FontConstants.cairoBold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'جرب اختيار حالة أخرى',
                              style: FontConstants.cairoStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // إذا لم توجد طاولات على الإطلاق
                    if (filteredTables.isEmpty && tables.isEmpty) {
                      return const Center(
                        child: Text('لا توجد طاولات في هذا الطابق'),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // الكشف عن الـ tablet باستخدام MediaQuery
                        final mediaQuery = MediaQuery.of(context);
                        final isTablet = mediaQuery.size.shortestSide >= 600;

                        // حساب عدد الأعمدة بناءً على نوع الجهاز
                        int crossAxisCount = 3; // افتراضي للهاتف
                        double childAspectRatio = 0.85; // للهاتف
                        double padding = 12.w;
                        double spacing = 12.w;

                        if (isTablet) {
                          // إعدادات الـ tablet
                          final screenWidth = constraints.maxWidth;

                          if (screenWidth > 1200) {
                            // Tablet كبير جداً
                            crossAxisCount = 6;
                            childAspectRatio = 1.5;
                            padding = 20.w;
                            spacing = 20.w;
                          } else if (screenWidth > 900) {
                            // Tablet كبير
                            crossAxisCount = 5;
                            childAspectRatio = 1.5;
                            padding = 18.w;
                            spacing = 18.w;
                          } else {
                            // Tablet صغير
                            crossAxisCount = 2;
                            childAspectRatio = 1.5;
                            padding = 16.w;
                            spacing = 16.w;
                          }
                        }

                        return RepaintBoundary(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(padding),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                ),
                            itemCount: filteredTables.length,
                            itemBuilder: (context, index) {
                              return RepaintBoundary(
                                child: TableItem(
                                  table: filteredTables[index],
                                  isTablet: isTablet,
                                ),
                              );
                            },
                          ),
                        );
                      },
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
                          onPressed: () => tablesController.refreshTables(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 16.h), // مسافة إضافية في الأسفل
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLegend(
    String text,
    String? image,
    int? status, {
    VoidCallback? onTap,
  }) {
    final tablesController = Get.find<TablesController>();
    return Obx(() {
      final isSelected = tablesController.selectedStatusFilter.value == status;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: Offset(0, 5.h),
              ),
            ],
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2.w)
                : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(image)),
                  ),
                ),
              if (image != null) SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  text,
                  style: FontConstants.cairoStyle(
                    fontSize: 11.sp,
                    weight: FontConstants.cairoMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: 4.w),
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

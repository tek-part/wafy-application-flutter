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
                    weight: FontWeight.w600,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          SizedBox(width: 10.w),
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
                  _buildStatusLegend(
                    'انتظار الدفع',
                    AppImages.emptyStateCircle,
                  ),
                  _buildStatusLegend('مشغول', AppImages.workingStateCircle),
                  _buildStatusLegend('متاح', AppImages.waitingPayStateCircle),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // عرض الطاولات
            Expanded(
              child: Obx(() {
                return tablesController.state.when(
                  initial: () =>
                      const Center(child: Text('اختر طابقاً لعرض الطاولات')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (tables) => RepaintBoundary(
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        return RepaintBoundary(
                          child: TableItem(table: tables[index]),
                        );
                      },
                    ),
                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLegend(String text, String image) {
    return Container(
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
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image)),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: FontConstants.cairoStyle(
              fontSize: 12.sp,
              weight: FontConstants.cairoMedium,
            ),
          ),
        ],
      ),
    );
  }
}

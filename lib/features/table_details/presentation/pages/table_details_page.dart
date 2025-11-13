import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import '../controllers/table_details_controller.dart';

class TableDetailsPage extends GetView<TableDetailsController> {
  final int tableId;
  final String? tableName;

  const TableDetailsPage({super.key, required this.tableId, this.tableName});

  @override
  Widget build(BuildContext context) {
    // تحميل تفاصيل الطاولة عند فتح الصفحة
    // وتعيين menuMode إلى addToTable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadTableDetails(tableId);

      // تعيين menuMode إلى addToTable عند فتح صفحة تفاصيل الطاولة
      if (Get.isRegistered<FullMenuController>()) {
        final menuController = Get.find<FullMenuController>();
        menuController.setTableId(tableId.toString());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            // إظهار loading indicator أثناء جلب الفاتورة
            if (controller.isLoadingInvoice.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 16.h),
                    Text(
                      'جاري تحميل الفاتورة...',
                      style: FontConstants.cairoStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            // المحتوى العادي عند عدم التحميل
            return Column(
              children: [
                CustomAppBar(
                  title: "تفاصيل الطاولة",
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 16.h),
                // عرض معلومات الطاولة مباشرة بدون استخدام ordersState
                _buildTableInfoCard(),
                SizedBox(height: 20.h),
                // عرض الفاتورة إذا كانت موجودة
                Obx(() {
                  if (controller.currentInvoiceId.value != null) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: Card(
                        color: AppColors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الفاتورة الحالية',
                                    style: FontConstants.cairoStyle(
                                      fontSize: 16.sp,
                                      weight: FontConstants.cairoBold,
                                    ),
                                  ),
                                  Text(
                                    'رقم الفاتورة: ${controller.currentInvoiceId.value}',
                                    style: FontConstants.cairoStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      Routes.tableInvoice,
                                      arguments: {'tableId': tableId},
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    'عرض تفاصيل الفاتورة',
                                    style: FontConstants.cairoStyle(
                                      fontSize: 16.sp,
                                      weight: FontConstants.cairoMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: 20.h),
                // قائمة العناصر المضافة
                Expanded(
                  child: Obx(() {
                    if (controller.pendingItems.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد عناصر مضافة',
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.pendingItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final item = controller.pendingItems[index];
                        return Card(
                          color: AppColors.white,
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.itemName} ${item.sizeName != null ? ' - ${item.sizeName}' : ''}",
                                        style: FontConstants.cairoStyle(
                                          fontSize: 16.sp,
                                          weight: FontConstants.cairoSemiBold,
                                        ),
                                      ),
                                      if (item.sizeName != null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          'الحجم: ${item.sizeName}',
                                          style: FontConstants.cairoStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      if (item.notes != null &&
                                          item.notes!.isNotEmpty) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          'ملاحظات: ${item.notes}',
                                          style: FontConstants.cairoStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (item.quantity > 1) {
                                                controller
                                                    .updatePendingItemQuantity(
                                                      index,
                                                      item.quantity - 1,
                                                    );
                                              }
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 28.h,
                                              decoration: BoxDecoration(
                                                color: item.quantity > 1
                                                    ? AppColors.primary
                                                    : Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            '${item.quantity}',
                                            style: FontConstants.cairoStyle(
                                              fontSize: 16.sp,
                                              weight: FontConstants.cairoBold,
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          GestureDetector(
                                            onTap: () {
                                              controller
                                                  .updatePendingItemQuantity(
                                                    index,
                                                    item.quantity + 1,
                                                  );
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 28.h,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    NumText(
                                      '${NumberFormatter.formatPrice(item.totalPrice)} د.ع',
                                      style: FontConstants.cairoStyle(
                                        fontSize: 16.sp,
                                        weight: FontConstants.cairoBold,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: () {
                                        controller.removePendingItem(index);
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                // زر حفظ الفاتورة - يظهر فقط إذا كانت هناك عناصر
                Obx(() {
                  if (controller.pendingItems.isEmpty) {
                    return const SizedBox.shrink(); // إخفاء الزر إذا لم تكن هناك عناصر
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSavingInvoice.value
                          ? null
                          : () {
                              controller.saveInvoice();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: controller.isSavingInvoice.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'جاري الحفظ...',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 16.sp,
                                    weight: FontConstants.cairoMedium,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'حفظ الفاتورة',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 16.sp,
                                    weight: FontConstants.cairoMedium,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // الانتقال للقائمة مع تمرير tableId وتغيير menuMode إلى addToTable
                      Get.toNamed(Routes.menu, arguments: {'tableId': tableId});
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'إضافة طلب جديد',
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTableInfoCard() {
    return Card(
      color: AppColors.white,
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الطاولة',
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoMedium,
                  ),
                ),
                NumText(tableName ?? tableId.toString()),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السعر',
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoMedium,
                  ),
                ),
                Obx(
                  () => NumText(
                    '${NumberFormatter.formatPrice(controller.totalPrice)} د.ع',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد العناصر',
                  style: FontConstants.cairoStyle(
                    fontSize: 16.sp,
                    weight: FontConstants.cairoMedium,
                  ),
                ),
                Obx(() => NumText('${controller.pendingItems.length}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

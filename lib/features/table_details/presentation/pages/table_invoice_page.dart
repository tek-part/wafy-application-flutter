import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';

import '../controllers/table_details_controller.dart';

class TableInvoicePage extends GetView<TableDetailsController> {
  final int tableId;

  const TableInvoicePage({super.key, required this.tableId});

  @override
  Widget build(BuildContext context) {
    // تحميل آخر فاتورة للطاولة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLastInvoice(tableId);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomAppBar(
                title: "الفاتورة",
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                // استخدام isLoadingInvoice بدلاً من invoiceState
                if (controller.isLoadingInvoice.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // إذا لم تكن هناك فاتورة
                if (controller.currentInvoiceId.value == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا توجد فاتورة للطاولة',
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => controller.loadLastInvoice(tableId),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                return _buildInvoiceContent();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات الطاولة
          Card(
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
                      NumText(tableId.toString()),
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
          ),
          SizedBox(height: 20.h),
          // قائمة العناصر
          Text(
            'العناصر',
            style: FontConstants.cairoStyle(
              fontSize: 18.sp,
              weight: FontConstants.cairoBold,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (controller.pendingItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    'لا توجد عناصر في الفاتورة',
                    style: FontConstants.cairoStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.pendingItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: 4.h),
                            Text(
                              'الكمية: ${item.quantity}',
                              style: FontConstants.cairoStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
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
          SizedBox(height: 20.h),
          // ملخص الفاتورة
          Card(
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع الفرعي',
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
                  Divider(),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع الكلي',
                        style: FontConstants.cairoStyle(
                          fontSize: 18.sp,
                          weight: FontConstants.cairoBold,
                        ),
                      ),
                      Obx(
                        () => NumText(
                          '${NumberFormatter.formatPrice(controller.totalPrice)} د.ع',
                          style: FontConstants.cairoStyle(
                            fontSize: 20.sp,
                            weight: FontConstants.cairoBold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // زر تغيير حالة الطاولة
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isUpdatingStatus.value
                    ? null
                    : () {
                        _showStatusDialog();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: controller.isUpdatingStatus.value
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'تغيير حالة الطاولة',
                        style: FontConstants.cairoStyle(
                          fontSize: 16.sp,
                          weight: FontConstants.cairoMedium,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'تغيير حالة الطاولة',
          style: FontConstants.cairoStyle(
            fontSize: 18.sp,
            weight: FontConstants.cairoBold,
            color: AppColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption(
              status: 0,
              statusName: 'متاح',
              color: Colors.green,
              icon: Icons.check_circle,
            ),
            SizedBox(height: 12.h),
            _buildStatusOption(
              status: 2,
              statusName: 'منتظر',
              color: Colors.orange,
              icon: Icons.access_time,
            ),
            SizedBox(height: 12.h),
            _buildStatusOption(
              status: 1,
              statusName: 'مشغول',
              color: Colors.red,
              icon: Icons.cancel,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'إلغاء',
              style: FontConstants.cairoStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildStatusOption({
    required int status,
    required String statusName,
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        Get.back();
        controller.updateTableStatus(status);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              statusName,
              style: FontConstants.cairoStyle(
                fontSize: 16.sp,
                weight: FontConstants.cairoMedium,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/core/widgets/num_text.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';

import '../controllers/table_details_controller.dart';

class TableInvoicePage extends GetView<TableDetailsController> {
  final int tableId;
  final String tableName;

  const TableInvoicePage({
    super.key,
    required this.tableId,
    required this.tableName,
  });

  @override
  Widget build(BuildContext context) {
    // تحميل آخر فاتورة للطاولة عند فتح الصفحة
    // لا نمسح newPendingItems عند فتح صفحة الفاتورة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLastInvoice(tableId, clearNewItems: false);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomAppBar(
                title: "الفاتورة",
                showBackButton: true,
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
                      Flexible(
                        child: Text(
                          'رقم الطاولة',
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoMedium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          tableName,
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'عدد العناصر',
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoMedium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Obx(
                          () => NumText(
                            '${controller.pendingItems.length}',
                            style: FontConstants.poppinsStyle(
                              fontSize: 16.sp,
                              weight: FontConstants.poppinsBold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${item.itemName}${item.sizeName != null ? ' - ${item.sizeName}' : ''}",
                                style: FontConstants.cairoStyle(
                                  fontSize: 16.sp,
                                  weight: FontConstants.cairoSemiBold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.sizeName != null) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  'الحجم: ${item.sizeName}',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (item.notes != null &&
                                  item.notes!.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  'ملاحظات: ${item.notes}',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NumText(
                              '${NumberFormatter.formatPrice(item.totalPrice)} د.ع',
                              style: FontConstants.poppinsStyle(
                                fontSize: 16.sp,
                                weight: FontConstants.poppinsBold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'الكمية: ${item.quantity}',
                              style: FontConstants.cairoStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Flexible(
                  //       child: Text(
                  //         'المجموع الفرعي',
                  //         style: FontConstants.cairoStyle(
                  //           fontSize: 16.sp,
                  //           weight: FontConstants.cairoMedium,
                  //         ),
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     SizedBox(width: 8.w),
                  //     Flexible(
                  //       child: Obx(
                  //         () => NumText(
                  //           '${NumberFormatter.formatPrice(controller.totalPrice)} د.ع',
                  //           style: FontConstants.poppinsStyle(
                  //             fontSize: 16.sp,
                  //             weight: FontConstants.poppinsBold,
                  //           ),
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.end,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8.h),
                  // Divider(),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'المجموع الكلي',
                          style: FontConstants.cairoStyle(
                            fontSize: 18.sp,
                            weight: FontConstants.cairoBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Obx(
                          () => NumText(
                            '${NumberFormatter.formatPrice(controller.totalPriceAll)} د.ع',
                            style: FontConstants.poppinsStyle(
                              fontSize: 20.sp,
                              weight: FontConstants.poppinsBold,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
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
          // زر إضافة عنصر
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // الانتقال للقائمة مع تمرير tableId وتغيير menuMode إلى addToTable
                Get.toNamed(
                  Routes.menu,
                  arguments: {'tableId': tableId, 'tableName': tableName},
                );
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
          SizedBox(height: 12.h),
          // زر تغيير حالة الطاولة
          // Obx(
          //   () => SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       onPressed: controller.isUpdatingStatus.value
          //           ? null
          //           : () {
          //               _showStatusDialog();
          //             },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.primary,
          //         foregroundColor: Colors.white,
          //         padding: EdgeInsets.symmetric(vertical: 12.h),
          //         disabledBackgroundColor: Colors.grey,
          //       ),
          //       child: controller.isUpdatingStatus.value
          //           ? SizedBox(
          //               height: 20.h,
          //               width: 20.w,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2,
          //                 valueColor: AlwaysStoppedAnimation<Color>(
          //                   Colors.white,
          //                 ),
          //               ),
          //             )
          //           : Text(
          //               'تغيير حالة الطاولة',
          //               style: FontConstants.cairoStyle(
          //                 fontSize: 16.sp,
          //                 weight: FontConstants.cairoMedium,
          //               ),
          //             ),
          //     ),
          //   ),
          // ),
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
        Get.back(); // إغلاق dialog اختيار الحالة
        _showConfirmStatusChangeDialog(status, statusName, color);
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

  void _showConfirmStatusChangeDialog(
    int status,
    String statusName,
    Color color,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'تأكيد تغيير الحالة',
          style: FontConstants.cairoStyle(
            fontSize: 18.sp,
            weight: FontConstants.cairoBold,
            color: AppColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هل أنت متأكد من تغيير حالة الطاولة إلى',
              style: FontConstants.cairoStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(8.r),
                color: color.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: color, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    statusName,
                    style: FontConstants.cairoStyle(
                      fontSize: 18.sp,
                      weight: FontConstants.cairoBold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: FontConstants.cairoStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // إغلاق dialog التأكيد
              controller.updateTableStatus(status);
            },
            child: Text(
              'تأكيد',
              style: FontConstants.cairoStyle(
                fontSize: 14.sp,
                weight: FontConstants.cairoBold,
                color: color,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

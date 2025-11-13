import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/features/menu/domain/entities/item_size.dart';
import 'package:wafy/features/menu/presentation/controllers/add_item_from_menu_controller.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/menu/presentation/bindings/menu_binding.dart';
import 'package:wafy/features/table_details/presentation/controllers/table_details_controller.dart';
import 'package:wafy/features/table_details/presentation/bindings/table_details_binding.dart';

class AddItemDialogMenu extends StatefulWidget {
  final String name;
  final String price;
  final bool hasSize;
  final int menuItemId;

  const AddItemDialogMenu({
    super.key,
    required this.name,
    required this.price,
    this.hasSize = false,
    required this.menuItemId,
  });

  @override
  State<AddItemDialogMenu> createState() => _AddItemDialogMenuState();
}

class _AddItemDialogMenuState extends State<AddItemDialogMenu> {
  bool _isInitialized = false;
  AddItemFromMenuController? _controller;

  @override
  void initState() {
    super.initState();
    // التأكد من وجود الـ controller
    if (!Get.isRegistered<AddItemFromMenuController>()) {
      final binding = MenuBinding();
      binding.dependencies();
    }

    // تهيئة البيانات مرة واحدة فقط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && mounted) {
        _isInitialized = true;
        _controller = Get.find<AddItemFromMenuController>();
        _controller!.setItemDetails(widget.name, widget.price);
        _controller!.loadItemSizes(widget.menuItemId);
      }
    });
  }

  @override
  void dispose() {
    // تنظيف الـ controller عند إغلاق الـ Dialog
    // لا نحذفه لأنه قد يكون مستخدماً في أماكن أخرى
    // لكن نعيد تعيين القيم الافتراضية
    if (Get.isRegistered<AddItemFromMenuController>()) {
      final controller = Get.find<AddItemFromMenuController>();
      controller.quantity.value = 1;
      controller.noteController.clear();
      controller.sizes.clear();
      controller.hasSize.value = false;
      controller.selectedSizeIndex.value = 0;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود الـ controller
    if (!Get.isRegistered<AddItemFromMenuController>()) {
      return const SizedBox.shrink();
    }

    final controller = _controller ?? Get.find<AddItemFromMenuController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.name,
                  style: FontConstants.cairoStyle(
                    fontSize: 24.sp,
                    weight: FontConstants.cairoBold,
                    color: AppColors.grayDarker,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // Size Selection (only show if hasSize is true)
                Obx(
                  () => controller.isLoadingSizes.value
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : controller.hasSize.value && controller.sizes.isNotEmpty
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                controller.sizes.length,
                                (index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: _sizeButton(
                                    size: controller.sizes[index],
                                    isSelected:
                                        controller.selectedSizeIndex.value ==
                                        index,
                                    onPressed: () {
                                      controller.setSelectedSizeIndex(index);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        )
                      : const SizedBox(),
                ),

                SizedBox(height: 24.h),
                // Price and Counter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Counter
                    Obx(
                      () => Row(
                        children: [
                          // Minus button
                          GestureDetector(
                            onTap: controller.decrementQuantity,
                            child: Icon(
                              CustomIconsDataType.category_item_remove_icon,
                              color: AppColors.grayDarker,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Quantity
                          Text(
                            '${controller.quantity.value}',
                            style: FontConstants.poppinsStyle(
                              fontSize: 14.sp,
                              weight: FontConstants.poppinsBold,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Plus button
                          GestureDetector(
                            onTap: controller.incrementQuantity,
                            child: Icon(
                              CustomIconsDataType.category_item_add_icon,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Obx(
                      () => Text(
                        '${NumberFormatter.formatPrice(controller.currentPrice)} د.ع.',
                        style: FontConstants.poppinsStyle(
                          fontSize: 16.sp,
                          weight: FontConstants.poppinsBold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Note Text Field
                Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: controller.noteController,
                    decoration: InputDecoration(
                      hintText: 'الوصف',
                      hintStyle: FontConstants.cairoStyle(
                        fontSize: 14.sp,
                        color: AppColors.grayDarker,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(height: 24.h),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // التحقق من menuMode وإضافة العنصر للطاولة إذا كان addToTable
                      try {
                        if (Get.isRegistered<FullMenuController>()) {
                          final menuController = Get.find<FullMenuController>();

                          if (menuController.menuMode.value ==
                              MenuMode.addToTable) {
                            // إضافة العنصر للطاولة
                            final tableIdStr = menuController.tableId.value;

                            if (tableIdStr.isNotEmpty) {
                              final tableId = int.tryParse(tableIdStr);

                              if (tableId != null) {
                                // محاولة الوصول إلى TableDetailsController
                                // إذا لم يكن مسجلاً، ننشئه
                                TableDetailsController tableController;
                                if (Get.isRegistered<
                                  TableDetailsController
                                >()) {
                                  tableController =
                                      Get.find<TableDetailsController>();
                                } else {
                                  // إنشاء instance جديد إذا لم يكن موجوداً
                                  // نحتاج إلى binding لإنشاء الـ controller
                                  final binding = TableDetailsBinding();
                                  binding.dependencies();
                                  tableController =
                                      Get.find<TableDetailsController>();
                                }

                                final selectedSize = controller.selectedSize;
                                final itemPrice = controller.currentPrice;

                                // تعيين tableId في الـ controller إذا لم يكن محدداً
                                if (tableController.currentTableId.value ==
                                    null) {
                                  tableController.currentTableId.value =
                                      tableId;
                                }

                                tableController.addItemToTable(
                                  menuItemId: widget.menuItemId,
                                  itemName: widget.name,
                                  price: itemPrice,
                                  quantity: controller.quantity.value,
                                  itemSizeId: selectedSize?.id,
                                  sizeName: selectedSize?.sizeName,
                                  notes:
                                      controller.noteController.text.isNotEmpty
                                      ? controller.noteController.text
                                      : null,
                                  tableId: tableId,
                                );
                                // إغلاق dialog الإضافة أولاً
                                Get.back();
                                // سيتم إظهار dialog النجاح من addItemToTable
                                return;
                              }
                            }
                          }
                        }
                      } catch (e) {
                        // في حالة حدوث خطأ، نستخدم السلوك الافتراضي
                      }
                      // السلوك الافتراضي
                      controller.addItem();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'إضافة',
                      style: FontConstants.cairoStyle(
                        fontSize: 16.sp,
                        weight: FontConstants.cairoBold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeButton({
    required ItemSize size,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grayDarker,
            width: 2,
          ),
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              size.sizeName,
              style: FontConstants.cairoStyle(
                fontSize: 14.sp,
                weight: FontConstants.cairoSemiBold,
                color: isSelected ? AppColors.white : AppColors.grayDarker,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${NumberFormatter.formatPrice(size.sizePrice)} د.ع',
              style: FontConstants.poppinsStyle(
                fontSize: 12.sp,
                weight: FontConstants.poppinsMedium,
                color: isSelected ? AppColors.white : AppColors.grayDarker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

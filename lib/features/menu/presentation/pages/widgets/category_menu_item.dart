import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/enums/menu_mode.dart';
import 'package:wafy/features/table_details/presentation/controllers/table_details_controller.dart';
import 'package:wafy/features/table_details/presentation/bindings/table_details_binding.dart';

class CategoryMenuItem extends StatelessWidget {
  final MenuItem menuItem;
  final bool showAddButton;
  final VoidCallback onAdd;
  final VoidCallback onTap;
  const CategoryMenuItem({
    super.key,
    required this.menuItem,
    required this.onAdd,
    this.showAddButton = false,
    required this.onTap,
  });

  // تحويل Base64 string إلى Uint8List للصورة
  Uint8List _base64ToImage(String base64String) {
    try {
      // إزالة data:image prefix إذا كان موجوداً
      if (base64String.contains(',')) {
        base64String = base64String.split(',')[1];
      }
      return base64Decode(base64String);
    } catch (e) {
      // في حالة الخطأ، إرجاع صورة فارغة
      return Uint8List(0);
    }
  }

  // التحقق من أن النص هو base64
  bool _isBase64(String? text) {
    if (text == null || text.isEmpty) return false;
    // التحقق من أن النص يبدأ بـ data:image أو يحتوي على base64 characters
    return text.contains('data:image') ||
        (text.length > 100 &&
            RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(text.split(',').last));
  }

  void _addItemDirectly() {
    // التحقق من menuMode وإضافة العنصر مباشرة إذا كان addToTable
    try {
      if (Get.isRegistered<FullMenuController>()) {
        final menuController = Get.find<FullMenuController>();

        if (menuController.menuMode.value == MenuMode.addToTable) {
          // إضافة العنصر للطاولة مباشرة
          final tableIdStr = menuController.tableId.value;

          if (tableIdStr.isNotEmpty) {
            final tableId = int.tryParse(tableIdStr);

            if (tableId != null) {
              // محاولة الوصول إلى TableDetailsController
              TableDetailsController tableController;
              if (Get.isRegistered<TableDetailsController>()) {
                tableController = Get.find<TableDetailsController>();
              } else {
                // إنشاء instance جديد إذا لم يكن موجوداً
                final binding = TableDetailsBinding();
                binding.dependencies();
                tableController = Get.find<TableDetailsController>();
              }

              // تعيين tableId في الـ controller إذا لم يكن محدداً
              if (tableController.currentTableId.value == null) {
                tableController.currentTableId.value = tableId;
              }

              // إضافة العنصر مباشرة بدون dialog
              tableController.addItemToTable(
                menuItemId: menuItem.id,
                itemName: menuItem.nameAr,
                price: menuItem.price,
                quantity: 1,
                itemSizeId: null,
                sizeName: null,
                notes: null,
                tableId: tableId,
              );
              return;
            }
          }
        }
      }
    } catch (e) {
      // في حالة حدوث خطأ، نستخدم السلوك الافتراضي (فتح dialog)
      onAdd();
      return;
    }
    // السلوك الافتراضي: فتح dialog
    onAdd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // عند الضغط على الكارد، فتح dialog
      child: Card(
        color: AppColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // الصورة أو النص
              Flexible(
                child:
                    (menuItem.itemImage == null || menuItem.itemImage!.isEmpty)
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          menuItem.nameAr,
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoBold,
                            color: AppColors.grayDarker,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : _isBase64(menuItem.itemImage)
                    ? Image.memory(
                        _base64ToImage(menuItem.itemImage!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            menuItem.nameAr,
                            style: FontConstants.cairoStyle(
                              fontSize: 16.sp,
                              weight: FontConstants.cairoBold,
                              color: AppColors.grayDarker,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          menuItem.nameAr,
                          style: FontConstants.cairoStyle(
                            fontSize: 16.sp,
                            weight: FontConstants.cairoBold,
                            color: AppColors.grayDarker,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ),

              SizedBox(height: 8.h),

              // معلومات السعر والاسم
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: (showAddButton)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              "${NumberFormatter.formatPrice(menuItem.price)} د.ع",
                              style: FontConstants.poppinsStyle(
                                fontSize: 10.sp,
                                weight: FontConstants.poppinsBold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              // عند الضغط على الأيقونة، إضافة مباشرة
                              _addItemDirectly();
                            },
                            child: Icon(
                              CustomIconsDataType.category_item_add_icon,
                              size: 28.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            menuItem.nameAr,
                            style: FontConstants.cairoStyle(
                              fontSize: 12.sp,
                              weight: FontConstants.cairoBold,
                              color: AppColors.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${NumberFormatter.formatPrice(menuItem.price)} د.ع ",
                            style: FontConstants.poppinsStyle(
                              fontSize: 12.sp,
                              weight: FontConstants.poppinsBold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

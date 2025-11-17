import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/font_constants.dart';
import 'package:wafy/core/utils/number_formatter.dart';
import 'package:wafy/features/menu/domain/entities/item_size.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/usecases/get_item_sizes.dart';
import 'package:wafy/features/menu/presentation/bindings/menu_binding.dart';

class MenuItemDetailsDialog extends StatefulWidget {
  final MenuItem menuItem;

  const MenuItemDetailsDialog({super.key, required this.menuItem});

  @override
  State<MenuItemDetailsDialog> createState() => _MenuItemDetailsDialogState();
}

class _MenuItemDetailsDialogState extends State<MenuItemDetailsDialog> {
  bool _isLoadingSizes = false;
  List<ItemSize> _sizes = [];

  @override
  void initState() {
    super.initState();
    _loadSizes();
  }

  Future<void> _loadSizes() async {
    try {
      // التأكد من وجود GetItemSizes
      if (!Get.isRegistered<GetItemSizes>()) {
        final binding = MenuBinding();
        binding.dependencies();
      }

      setState(() {
        _isLoadingSizes = true;
      });

      final getItemSizes = Get.find<GetItemSizes>();
      final result = await getItemSizes(widget.menuItem.id);

      result.fold(
        (failure) {
          setState(() {
            _sizes = [];
            _isLoadingSizes = false;
          });
        },
        (sizes) {
          setState(() {
            _sizes = sizes;
            _isLoadingSizes = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _sizes = [];
        _isLoadingSizes = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.menuItem.itemImage != null &&
        widget.menuItem.itemImage!.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image or Name
              Container(
                width: double.infinity,
                height: 250.h,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: hasImage && _isBase64(widget.menuItem.itemImage)
                      ? Image.memory(
                          _base64ToImage(widget.menuItem.itemImage!),
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 48.sp,
                                  color: AppColors.grayDarker,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  widget.menuItem.nameAr,
                                  style: FontConstants.cairoStyle(
                                    fontSize: 18.sp,
                                    weight: FontConstants.cairoBold,
                                    color: AppColors.grayDarker,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            widget.menuItem.nameAr,
                            style: FontConstants.cairoStyle(
                              fontSize: 24.sp,
                              weight: FontConstants.cairoBold,
                              color: AppColors.grayDarker,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              // Description
              if (widget.menuItem.description.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    widget.menuItem.description,
                    style: FontConstants.cairoStyle(
                      fontSize: 14.sp,
                      weight: FontConstants.cairoRegular,
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),

              // Sizes
              if (_isLoadingSizes)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (_sizes.isNotEmpty) ...[
                if (widget.menuItem.description.isNotEmpty)
                  SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأحجام المتاحة:',
                        style: FontConstants.cairoStyle(
                          fontSize: 16.sp,
                          weight: FontConstants.cairoBold,
                          color: AppColors.text,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _sizes.map((size) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  size.sizeName,
                                  style: FontConstants.cairoStyle(
                                    fontSize: 14.sp,
                                    weight: FontConstants.cairoSemiBold,
                                    color: AppColors.text,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${NumberFormatter.formatPrice(size.sizePrice)} د.ع',
                                  style: FontConstants.cairoStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              // Close Button
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'إغلاق',
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
    );
  }
}

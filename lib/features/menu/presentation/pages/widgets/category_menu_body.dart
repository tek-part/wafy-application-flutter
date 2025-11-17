import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/usecases/get_item_sizes.dart';
import 'package:wafy/features/menu/presentation/bindings/menu_binding.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/add_item_dialog_menu.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_item.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/menu_item_details_dialog.dart';

class CategoryMenuBody extends StatelessWidget {
  final List<MenuItem> menuItems;
  final bool showAddButton;

  const CategoryMenuBody({
    super.key,
    required this.menuItems,
    required this.showAddButton,
  });

  // دالة للتحقق من وجود وصف أو أحجام للعنصر
  Future<bool> _hasDescriptionOrSizes(MenuItem menuItem) async {
    // التحقق من الوصف أولاً
    if (menuItem.description.isNotEmpty) {
      return true;
    }

    // التحقق من الأحجام
    try {
      // التأكد من وجود GetItemSizes
      if (!Get.isRegistered<GetItemSizes>()) {
        final binding = MenuBinding();
        binding.dependencies();
      }

      final getItemSizes = Get.find<GetItemSizes>();
      final result = await getItemSizes(menuItem.id);

      return result.fold(
        (failure) => false, // في حالة الخطأ، لا يوجد أحجام
        (sizes) => sizes.isNotEmpty, // إذا كانت هناك أحجام
      );
    } catch (e) {
      // في حالة الخطأ، نعتبر أنه لا يوجد أحجام
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // حساب عدد الأعمدة بناءً على عرض الشاشة
        final screenWidth = constraints.maxWidth;
        int crossAxisCount = 2; // افتراضي للهاتف

        if (screenWidth > 600) {
          // Tablet صغير
          crossAxisCount = 3;
        }
        if (screenWidth > 900) {
          // Tablet كبير
          crossAxisCount = 4;
        }
        if (screenWidth > 1200) {
          // شاشة كبيرة جداً
          crossAxisCount = 5;
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return CategoryMenuItem(
              onTap: () async {
                if (showAddButton) {
                  // إذا كان showAddButton = true، فتح dialog الإضافة
                  showDialog(
                    context: context,
                    builder: (context) => AddItemDialogMenu(
                      name: menuItems[index].nameAr,
                      price: menuItems[index].price.toString(),
                      hasSize: true, // يمكنك تغيير هذا حسب نوع العنصر
                      menuItemId: menuItems[index].id,
                    ),
                  );
                } else {
                  // إذا كان showAddButton = false، فتح dialog الوصف فقط إذا كان هناك وصف أو أحجام
                  final hasDescriptionOrSizes = await _hasDescriptionOrSizes(
                    menuItems[index],
                  );
                  if (hasDescriptionOrSizes) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            MenuItemDetailsDialog(menuItem: menuItems[index]),
                      );
                    }
                  }
                }
              },
              menuItem: menuItems[index],
              showAddButton: showAddButton,
              onAdd: () {
                // عند الضغط على أيقونة الإضافة، فتح dialog الإضافة
                // (هذا سيتم استبداله بـ _addItemDirectly في category_menu_item)
                showDialog(
                  context: context,
                  builder: (context) => AddItemDialogMenu(
                    name: menuItems[index].nameAr,
                    price: menuItems[index].price.toString(),
                    hasSize: true, // يمكنك تغيير هذا حسب نوع العنصر
                    menuItemId: menuItems[index].id,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

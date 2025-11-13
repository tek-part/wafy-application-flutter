import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/presentation/controllers/menu_controller.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/add_item_dialog_menu.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/category_menu_item.dart';
import 'package:wafy/features/menu/presentation/pages/widgets/menu_item_details_dialog.dart';
import 'package:wafy/features/table_details/presentation/controllers/table_details_controller.dart';

class CategoryMenuBody extends StatelessWidget {
  final List<MenuItem> menuItems;
  final bool showAddButton;

  const CategoryMenuBody({
    super.key,
    required this.menuItems,
    required this.showAddButton,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return CategoryMenuItem(
          onTap: () {
            // عرض الـ dialog فقط إذا كان الوصف غير فارغ
            if (menuItems[index].description.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => MenuItemDetailsDialog(
                  menuItem: menuItems[index],
                ),
              );
            }
          },
          menuItem: menuItems[index],
          showAddButton: showAddButton,
          onAdd: () {
            // show Dialog to add quantity
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
  }
}

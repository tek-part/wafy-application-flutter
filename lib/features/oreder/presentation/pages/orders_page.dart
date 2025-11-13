import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/home/presentation/pages/widgets/orders_page_item.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              CustomAppBar(
                title: "الطلبات",
                icon: CustomIconsDataType.tables_bottom_nav_icon,
              ),

              SizedBox(height: 16.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 220.h,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return OrdersPageItem(
                      tableNumber: index.toString(),
                      orderName: "شورما",
                      price: "480",
                      time: "5.30 Am",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

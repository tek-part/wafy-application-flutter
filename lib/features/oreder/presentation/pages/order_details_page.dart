import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/core/theme/colors.dart';
import 'package:wafy/core/utils/custom_icons_data_type_icons.dart';
import 'package:wafy/features/home/presentation/pages/widgets/custom_app_bar.dart';
import 'package:wafy/features/oreder/presentation/pages/orders_details_printed_page.dart';
import 'package:wafy/features/oreder/presentation/pages/orders_details_unprinted_page.dart';
import 'package:wafy/core/utils/font_constants.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              CustomAppBar(
                title: "تفاصيل الطلب",
                icon: CustomIconsDataType.tables_bottom_nav_icon,
                onPressed: () {
                  // pop up
                  Get.back();
                },
              ),

              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.jumpToPage(0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 0
                            ? AppColors.primary
                            : Colors.grey[300],
                        foregroundColor: _currentPage == 0
                            ? Colors.white
                            : AppColors.text,
                      ),
                      child: Text(
                        'المطلوب',
                        style: FontConstants.cairoStyle(
                          fontSize: 14.sp,
                          weight: FontConstants.cairoMedium,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.jumpToPage(1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 0
                            ? Colors.grey[200]
                            : AppColors.primary,
                        foregroundColor: _currentPage == 1
                            ? Colors.white
                            : AppColors.text,
                      ),
                      child: Text(
                        'الطلبات المطبوعة',
                        style: FontConstants.cairoStyle(
                          fontSize: 14.sp,
                          weight: FontConstants.cairoMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const OrdersDetailsUnprintedPage(),
                    const OrdersDetailsPrintedPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _currentPage == 0
          ? Container(
              height: 50.h,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16.h),
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
                child: Text("طباعه الطلب"),
              ),
            )
          : null,
    );
  }
}

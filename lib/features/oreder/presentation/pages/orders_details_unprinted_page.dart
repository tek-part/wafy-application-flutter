import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wafy/features/oreder/presentation/controllers/unprinted_order_controller.dart';
import 'package:wafy/features/oreder/presentation/pages/widgets/orders_details_unprinted_item.dart';

class OrdersDetailsUnprintedPage extends GetView<UnprintedOrderController> {
  const OrdersDetailsUnprintedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        return OrdersDetailsUnprintedItem(
          orderName: 'Order $index',
          count: '10',
          price: '100',
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10.h);
      },
    );
  }
}

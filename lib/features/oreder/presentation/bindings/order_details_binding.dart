import 'package:get/get.dart';
import 'package:wafy/features/oreder/presentation/controllers/printed_order_controller.dart';
import 'package:wafy/features/oreder/presentation/controllers/unprinted_order_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintedOrderController>(() => PrintedOrderController());
    Get.lazyPut<UnprintedOrderController>(() => UnprintedOrderController());
  }
}

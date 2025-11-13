import 'package:get/get.dart';
import 'package:wafy/core/network/api_client.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

import '../../data/datasources/table_details_remote_datasource.dart';
import '../../data/repositories/table_details_repository_impl.dart';
import '../../domain/repositories/table_details_repository.dart';
import '../../domain/usecases/add_item_to_table.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/usecases/get_last_invoice_by_table_id.dart';
import '../../domain/usecases/get_table_invoice.dart';
import '../../domain/usecases/get_table_orders.dart';
import '../../domain/usecases/update_invoice.dart';
import '../../domain/usecases/update_table_status.dart';
import '../controllers/table_details_controller.dart';

class TableDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<TableDetailsRemoteDataSource>(
      () => TableDetailsRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
        invoiceApiClient: Get.isRegistered<ApiClient>(tag: 'invoice')
            ? Get.find<ApiClient>(tag: 'invoice')
            : null,
      ),
    );

    // Repositories
    Get.lazyPut<TableDetailsRepository>(
      () => TableDetailsRepositoryImpl(
        remoteDataSource: Get.find<TableDetailsRemoteDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut<GetTableOrders>(
      () => GetTableOrders(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<GetTableInvoice>(
      () => GetTableInvoice(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<AddItemToTable>(
      () => AddItemToTable(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<CreateInvoice>(
      () => CreateInvoice(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<GetLastInvoiceByTableId>(
      () => GetLastInvoiceByTableId(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<UpdateInvoice>(
      () => UpdateInvoice(Get.find<TableDetailsRepository>()),
    );
    Get.lazyPut<UpdateTableStatus>(
      () => UpdateTableStatus(Get.find<TableDetailsRepository>()),
    );

    // Controllers
    // استخدام Get.put مع permanent: true لضمان أن الـ controller يبقى في الذاكرة
    // حتى بعد إغلاق صفحة تفاصيل الطاولة، حتى نتمكن من إضافة العناصر من صفحة القائمة
    if (!Get.isRegistered<TableDetailsController>()) {
      // محاولة الحصول على MenuRepository إذا كان مسجلاً
      MenuRepository? menuRepository;
      try {
        if (Get.isRegistered<MenuRepository>()) {
          menuRepository = Get.find<MenuRepository>();
        }
      } catch (e) {
        // إذا لم يكن MenuRepository مسجلاً، لا بأس
        menuRepository = null;
      }

      Get.put<TableDetailsController>(
        TableDetailsController(
          Get.find<GetTableOrders>(),
          Get.find<GetTableInvoice>(),
          Get.find<CreateInvoice>(),
          Get.find<GetLastInvoiceByTableId>(),
          Get.find<UpdateInvoice>(),
          Get.find<UpdateTableStatus>(),
          menuRepository: menuRepository,
        ),
        permanent: true, // يبقى في الذاكرة حتى بعد إغلاق الصفحة
      );
    }
  }
}

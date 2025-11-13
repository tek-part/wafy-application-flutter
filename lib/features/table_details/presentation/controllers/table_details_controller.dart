import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/table_order_item.dart';
import '../../domain/entities/pending_order_item.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_main.dart';
import '../../domain/usecases/get_table_orders.dart';
import '../../domain/usecases/get_table_invoice.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/usecases/get_last_invoice_by_table_id.dart';
import '../../domain/usecases/update_invoice.dart';
import '../../domain/usecases/update_table_status.dart';
import '../states/table_orders_state.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';
import 'package:wafy/core/services/user_service.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';

class TableDetailsController extends GetxController {
  final GetTableOrders _getTableOrders;
  final GetTableInvoice _getTableInvoice;
  final CreateInvoice _createInvoice;
  final GetLastInvoiceByTableId _getLastInvoiceByTableId;
  final UpdateInvoice _updateInvoice;
  final UpdateTableStatus _updateTableStatus;
  final MenuRepository? _menuRepository; // Optional for getting item names

  TableDetailsController(
    this._getTableOrders,
    this._getTableInvoice,
    this._createInvoice,
    this._getLastInvoiceByTableId,
    this._updateInvoice,
    this._updateTableStatus, {
    MenuRepository? menuRepository,
  }) : _menuRepository = menuRepository;

  final _ordersState = const TableOrdersState.initial().obs;
  TableOrdersState get ordersState => _ordersState.value;

  final _invoiceState = const TableOrdersState.initial().obs;
  TableOrdersState get invoiceState => _invoiceState.value;

  var orders = <TableOrderItem>[].obs;
  var currentTableId = Rxn<int>();
  var currentTable = Rxn<TableEntity>();

  // قائمة العناصر المضافة محلياً (قبل الحفظ)
  var pendingItems = <PendingOrderItem>[].obs;

  // معلومات الفاتورة
  var currentInvoiceId = Rxn<int>();
  var isLoadingInvoice = false.obs;
  var isSavingInvoice = false.obs;
  var isUpdatingStatus = false.obs;

  Future<void> loadTableDetails(int tableId) async {
    currentTableId.value = tableId;
    // البيانات تأتي من loadLastInvoice، لا حاجة لـ loadTableOrders
    await loadLastInvoice(tableId);
  }

  Future<void> loadTableOrders(int tableId) async {
    _ordersState.value = const TableOrdersState.loading();

    try {
      final result = await _getTableOrders(tableId);

      result.fold(
        (failure) {
          _ordersState.value = TableOrdersState.error(failure.message);
        },
        (ordersList) {
          orders.value = ordersList;
          _ordersState.value = TableOrdersState.success(ordersList);
        },
      );
    } catch (e) {
      _ordersState.value = TableOrdersState.error('خطأ غير متوقع: $e');
    }
  }

  Future<void> loadTableInvoice(int tableId) async {
    _invoiceState.value = const TableOrdersState.loading();

    try {
      final result = await _getTableInvoice(tableId);

      result.fold(
        (failure) {
          _invoiceState.value = TableOrdersState.error(failure.message);
        },
        (invoice) {
          _invoiceState.value = TableOrdersState.success([]);
        },
      );
    } catch (e) {
      _invoiceState.value = TableOrdersState.error('خطأ غير متوقع: $e');
    }
  }

  Future<void> addItemToTable({
    required int menuItemId,
    required String itemName,
    required double price,
    required int quantity,
    int? itemSizeId,
    String? sizeName,
    String? notes,
    int? tableId,
  }) async {
    print('=== addItemToTable called ===');
    print('menuItemId: $menuItemId');
    print('itemName: $itemName');
    print('price: $price');
    print('quantity: $quantity');
    print('itemSizeId: $itemSizeId');
    print('sizeName: $sizeName');
    print('notes: $notes');
    print('tableId parameter: $tableId');
    print('currentTableId.value: ${currentTableId.value}');

    final targetTableId = tableId ?? currentTableId.value;
    print('targetTableId: $targetTableId');

    if (targetTableId == null) {
      print('ERROR: targetTableId is null');
      Get.snackbar('خطأ', 'لم يتم تحديد الطاولة');
      return;
    }

    // إضافة العنصر للقائمة المحلية
    final pendingItem = PendingOrderItem(
      menuItemId: menuItemId,
      itemName: itemName,
      price: price,
      quantity: quantity,
      itemSizeId: itemSizeId,
      sizeName: sizeName,
      notes: notes,
    );

    print(
      'PendingItem created: ${pendingItem.itemName}, ${pendingItem.price}, ${pendingItem.quantity}',
    );
    print('pendingItems length before: ${pendingItems.length}');

    pendingItems.add(pendingItem);

    print('pendingItems length after: ${pendingItems.length}');
    print('=== addItemToTable completed ===');

    // إظهار dialog عند إضافة العنصر بنجاح
    Get.dialog(
      AlertDialog(
        title: Text(
          'نجح',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text('تم إضافة $itemName بنجاح'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // إغلاق dialog
            },
            child: Text('موافق'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void removePendingItem(int index) {
    if (index >= 0 && index < pendingItems.length) {
      pendingItems.removeAt(index);
      Get.snackbar('نجح', 'تم حذف العنصر');
    }
  }

  void updatePendingItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < pendingItems.length && newQuantity > 0) {
      final item = pendingItems[index];
      pendingItems[index] = PendingOrderItem(
        menuItemId: item.menuItemId,
        itemName: item.itemName,
        price: item.price,
        quantity: newQuantity,
        itemSizeId: item.itemSizeId,
        sizeName: item.sizeName,
        notes: item.notes,
      );
    }
  }

  Future<void> refreshOrders() async {
    if (currentTableId.value != null) {
      await loadTableOrders(currentTableId.value!);
    }
  }

  double get totalPrice {
    return pendingItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> loadLastInvoice(int tableId) async {
    isLoadingInvoice.value = true;
    _invoiceState.value = const TableOrdersState.loading();
    try {
      final result = await _getLastInvoiceByTableId(tableId);
      result.fold(
        (failure) {
          // إذا لم توجد فاتورة، لا بأس
          currentInvoiceId.value = null;
          pendingItems.clear();
          _invoiceState.value = TableOrdersState.error(failure.message);
        },
        (invoiceData) {
          // invoiceData هو Map يحتوي على invoiceMain و details
          final invoiceMain = invoiceData['invoiceMain'] as InvoiceMain;
          final details = invoiceData['details'] as List<InvoiceDetail>;

          currentInvoiceId.value = invoiceMain.invoiceId;

          // تحويل InvoiceDetail إلى PendingOrderItem مباشرة من البيانات
          final List<PendingOrderItem> loadedItems = details.map((detail) {
            return PendingOrderItem(
              menuItemId: detail.itemId,
              // استخدام itemName من API مباشرة، أو fallback إلى 'عنصر {itemId}'
              itemName: detail.itemName ?? 'عنصر ${detail.itemId}',
              price: detail.price,
              quantity: detail.quantity.toInt(),
              itemSizeId: detail.itemSizeId,
              // استخدام sizeName من API مباشرة
              sizeName: detail.sizeName,
              notes: detail.notice,
            );
          }).toList();

          // تحديث pendingItems بالعناصر المحملة
          pendingItems.value = loadedItems;

          // تحديث invoiceState
          _invoiceState.value = TableOrdersState.success([]);
        },
      );
    } catch (e) {
      currentInvoiceId.value = null;
      pendingItems.clear();
      _invoiceState.value = TableOrdersState.error('خطأ غير متوقع: $e');
    } finally {
      isLoadingInvoice.value = false;
    }
  }

  Future<void> saveInvoice() async {
    final targetTableId = currentTableId.value;
    if (targetTableId == null) {
      Get.snackbar('خطأ', 'لم يتم تحديد الطاولة');
      return;
    }

    if (pendingItems.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد عناصر للحفظ');
      return;
    }

    // الحصول على المستخدم الحالي
    final userService = Get.find<UserService>();
    final currentUser = userService.currentUser;
    if (currentUser == null) {
      Get.snackbar('خطأ', 'لم يتم العثور على المستخدم');
      return;
    }

    isSavingInvoice.value = true;

    try {
      // تحويل pendingItems إلى InvoiceDetail
      final details = pendingItems.map((item) {
        return InvoiceDetail(
          itemId: item.menuItemId,
          quantity: item.quantity.toDouble(),
          price: item.price,
          itemSizeId: item.itemSizeId,
          notice: item.notes,
        );
      }).toList();

      final result = currentInvoiceId.value == null
          ? await _createInvoice(
              rstableId: targetTableId,
              userId: currentUser.id,
              details: details,
            )
          : await _updateInvoice(
              invoiceId: currentInvoiceId.value!,
              rstableId: targetTableId,
              userId: currentUser.id,
              details: details,
            );

      result.fold(
        (failure) {
          Get.snackbar('خطأ', failure.message);
        },
        (invoiceId) async {
          currentInvoiceId.value = invoiceId;
          pendingItems.clear();

          // إظهار dialog النجاح
          Get.dialog(
            AlertDialog(
              title: Text(
                'نجح',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Text('تم إنشاء الفاتورة بنجاح'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // إغلاق dialog
                  },
                  child: Text('موافق'),
                ),
              ],
            ),
            barrierDismissible: true,
          );

          // إعادة تحميل الطلبات
          await loadTableOrders(targetTableId);

          // استدعاء API لجلب آخر فاتورة للطاولة
          await loadLastInvoice(targetTableId);
        },
      );
    } catch (e) {
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
    } finally {
      isSavingInvoice.value = false;
    }
  }

  Future<void> updateTableStatus(int status) async {
    final targetTableId = currentTableId.value;
    if (targetTableId == null) {
      Get.snackbar('خطأ', 'لم يتم تحديد الطاولة');
      return;
    }

    isUpdatingStatus.value = true;

    try {
      final result = await _updateTableStatus(
        rstableId: targetTableId,
        status: status,
      );

      result.fold(
        (failure) {
          Get.snackbar('خطأ', failure.message);
        },
        (response) {
          final message =
              response['message'] as String? ?? 'تم تحديث حالة الطاولة بنجاح';
          final newStatusName = response['newStatusName'] as String? ?? '';
          final oldStatusName = response['oldStatusName'] as String? ?? '';

          Get.snackbar('نجح', message);

          // تحديث حالة الطاولة في TablesController إذا كان موجوداً
          if (Get.isRegistered<TablesController>()) {
            final tablesController = Get.find<TablesController>();
            tablesController.refreshTableStatus(targetTableId);
          }
        },
      );
    } catch (e) {
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}

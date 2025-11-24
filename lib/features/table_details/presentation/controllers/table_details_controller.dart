import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/services/user_service.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_main.dart';
import '../../domain/entities/pending_order_item.dart';
import '../../domain/entities/table_order_item.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/usecases/get_last_invoice_by_table_id.dart';
import '../../domain/usecases/get_table_invoice.dart';
import '../../domain/usecases/get_table_orders.dart';
import '../../domain/usecases/update_invoice.dart';
import '../../domain/usecases/update_table_status.dart';
import '../states/table_orders_state.dart';

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
  var currentTableName = ''.obs;

  // قائمة العناصر المضافة محلياً (قبل الحفظ) - للتوافق مع الكود القديم
  var pendingItems = <PendingOrderItem>[].obs;

  // قائمة العناصر المضافة حديثاً (لم يتم حفظها بعد)
  var newPendingItems = <PendingOrderItem>[].obs;

  // قائمة العناصر المحفوظة في الفاتورة
  var savedItems = <PendingOrderItem>[].obs;

  // معلومات الفاتورة
  var currentInvoiceId = Rxn<int>();
  var isLoadingInvoice = false.obs;
  var isSavingInvoice = false.obs;
  var isUpdatingStatus = false.obs;

  Future<void> loadTableDetails(int tableId, {String? tableName}) async {
    // إذا كانت البيانات محملة لنفس الطاولة، لا حاجة لإعادة التحميل
    if (currentTableId.value == tableId && savedItems.isNotEmpty) {
      // فقط تحديث اسم الطاولة إذا كان مختلفاً
      if (tableName != null && currentTableName.value != tableName) {
        currentTableName.value = tableName;
      }
      return;
    }

    currentTableId.value = tableId;
    if (tableName != null) {
      currentTableName.value = tableName;
    }
    // البيانات تأتي من loadLastInvoice، لا حاجة لـ loadTableOrders
    // استخدام clearNewItems: false للحفاظ على العناصر المضافة حديثاً
    await loadLastInvoice(tableId, clearNewItems: false);
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

    // التحقق من وجود عنصر بنفس menuItemId و itemSizeId في newPendingItems
    final existingItemIndex = newPendingItems.indexWhere(
      (item) => item.menuItemId == menuItemId && item.itemSizeId == itemSizeId,
    );

    if (existingItemIndex != -1) {
      // إذا وُجد عنصر بنفس menuItemId و itemSizeId، زيادة الكمية فقط
      final existingItem = newPendingItems[existingItemIndex];
      newPendingItems[existingItemIndex] = PendingOrderItem(
        menuItemId: existingItem.menuItemId,
        itemName: existingItem.itemName,
        price: existingItem.price,
        quantity: existingItem.quantity + quantity,
        itemSizeId: existingItem.itemSizeId,
        sizeName: existingItem.sizeName,
        notes: existingItem.notes, // الاحتفاظ بملاحظات العنصر الأول
      );
      print(
        'Updated existing item quantity: ${newPendingItems[existingItemIndex].quantity}',
      );
    } else {
      // إذا لم يوجد، إضافة عنصر جديد
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
      print('newPendingItems length before: ${newPendingItems.length}');

      newPendingItems.add(pendingItem);

      print('newPendingItems length after: ${newPendingItems.length}');
    }

    // تحديث pendingItems للتوافق مع الكود القديم
    pendingItems.value = [...savedItems, ...newPendingItems];

    print('=== addItemToTable completed ===');

    // // إظهار رسالة نجاح باستخدام snackbar
    // Get.snackbar(
    //   'نجح',
    //   'تم إضافة $itemName بنجاح إلى الفاتورة',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: Duration(seconds: 2),
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
  }

  void removePendingItem(int index) {
    if (index >= 0 && index < newPendingItems.length) {
      newPendingItems.removeAt(index);
      // تحديث pendingItems للتوافق مع الكود القديم
      pendingItems.value = [...savedItems, ...newPendingItems];
      Get.snackbar('نجح', 'تم حذف العنصر');
    }
  }

  void updatePendingItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < newPendingItems.length && newQuantity > 0) {
      final item = newPendingItems[index];
      newPendingItems[index] = PendingOrderItem(
        menuItemId: item.menuItemId,
        itemName: item.itemName,
        price: item.price,
        quantity: newQuantity,
        itemSizeId: item.itemSizeId,
        sizeName: item.sizeName,
        notes: item.notes,
      );
      // تحديث pendingItems للتوافق مع الكود القديم
      pendingItems.value = [...savedItems, ...newPendingItems];
    }
  }

  Future<void> refreshOrders() async {
    if (currentTableId.value != null) {
      await loadTableOrders(currentTableId.value!);
    }
  }

  // المجموع الكلي للعناصر المضافة حديثاً فقط
  double get totalPrice {
    return newPendingItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  // المجموع الكلي لجميع العناصر (المحفوظة + الجديدة)
  double get totalPriceAll {
    final savedTotal = savedItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final newTotal = newPendingItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final total = savedTotal + newTotal;
    print('=== totalPriceAll calculation ===');
    print('savedItems count: ${savedItems.length}');
    print('savedTotal: $savedTotal');
    print('newPendingItems count: ${newPendingItems.length}');
    print('newTotal: $newTotal');
    print('total: $total');
    print('================================');
    return total;
  }

  Future<void> loadLastInvoice(int tableId, {bool clearNewItems = true}) async {
    isLoadingInvoice.value = true;
    _invoiceState.value = const TableOrdersState.loading();
    try {
      final result = await _getLastInvoiceByTableId(tableId);
      result.fold(
        (failure) {
          // إذا لم توجد فاتورة، لا بأس
          currentInvoiceId.value = null;
          savedItems.clear();
          if (clearNewItems) {
            newPendingItems.clear();
          }
          pendingItems.value = [...savedItems, ...newPendingItems];
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

          // حفظ العناصر المحملة في savedItems (العناصر المحفوظة)
          savedItems.value = loadedItems;
          // مسح العناصر المضافة حديثاً فقط إذا كان clearNewItems = true
          if (clearNewItems) {
            newPendingItems.clear();
          }
          // تحديث pendingItems للتوافق مع الكود القديم
          pendingItems.value = [...savedItems, ...newPendingItems];

          print('=== loadLastInvoice completed ===');
          print('savedItems count: ${savedItems.length}');
          print('newPendingItems count: ${newPendingItems.length}');
          for (var item in savedItems) {
            print(
              'Item: ${item.itemName}, Price: ${item.price}, Quantity: ${item.quantity}, Total: ${item.totalPrice}',
            );
          }
          print('totalPriceAll: $totalPriceAll');
          print('==================================');

          // تحديث invoiceState
          _invoiceState.value = TableOrdersState.success([]);
        },
      );
    } catch (e) {
      currentInvoiceId.value = null;
      savedItems.clear();
      // لا نمسح newPendingItems في حالة الخطأ إذا كان clearNewItems = false
      // لكن في حالة الخطأ، يجب مسحها دائماً
      newPendingItems.clear();
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

    if (newPendingItems.isEmpty) {
      Get.snackbar('خطأ', 'لا توجد عناصر جديدة للحفظ');
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
      // دمج savedItems مع newPendingItems عند الحفظ
      final allItems = [...savedItems, ...newPendingItems];

      // تحويل جميع العناصر إلى InvoiceDetail
      final details = allItems.map((item) {
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
          // نقل العناصر المضافة حديثاً إلى المحفوظة ومسحها
          savedItems.value = [...savedItems, ...newPendingItems];
          newPendingItems.clear();
          pendingItems.value = savedItems;

          // إعادة تحميل الطلبات
          await loadTableOrders(targetTableId);

          // استدعاء API لجلب آخر فاتورة للطاولة
          await loadLastInvoice(targetTableId);

          // تحديث حالة جميع الطاولات في شاشة الرئيسية
          if (Get.isRegistered<TablesController>()) {
            final tablesController = Get.find<TablesController>();
            await tablesController.refreshTables();
          }

          // الانتقال إلى شاشة الرئيسية (go بدلاً من push)
          Get.offNamed(Routes.home);
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

          Get.snackbar('نجح', message);

          // تحديث حالة الطاولة في TablesController إذا كان موجوداً
          if (Get.isRegistered<TablesController>()) {
            final tablesController = Get.find<TablesController>();
            tablesController.refreshTableStatus(targetTableId);
          }

          // الانتقال إلى Home بعد تغيير حالة الطاولة بنجاح
          // استخدام Get.offNamed بدلاً من Get.offAllNamed للحفاظ على الـ controllers المسجلة بشكل permanent
          Get.offNamed(Routes.home);
        },
      );
    } catch (e) {
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}

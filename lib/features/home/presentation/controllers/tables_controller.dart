import 'dart:async';
import 'package:get/get.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';
import 'package:wafy/features/home/domain/entities/table_status_entity.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_usecase.dart';
import 'package:wafy/features/home/domain/usecases/get_tables_status_usecase.dart';
import 'package:wafy/features/home/presentation/states/tables_view_state.dart';

class TablesController extends GetxController {
  final GetTables _getTables;
  final GetTablesStatus _getTablesStatus;

  TablesController(this._getTables, this._getTablesStatus);

  final _state = const TablesViewState.initial().obs;
  TablesViewState get state => _state.value;

  var tables = <TableEntity>[].obs;
  var selectedFloorId = Rxn<int>();

  StreamSubscription<List<TableStatusEntity>>? _statusStreamSubscription;
  Timer? _statusTimer;

  Future<void> loadTables(int floorId) async {
    _state.value = const TablesViewState.loading();
    selectedFloorId.value = floorId;

    // إيقاف الـ stream السابق إذا كان موجوداً
    _stopStatusStream();

    try {
      final result = await _getTables(floorId);

      result.fold(
        (failure) {
          _state.value = TablesViewState.error(failure.message);
        },
        (tablesList) {
          tables.value = tablesList;
          _state.value = TablesViewState.success(tablesList);
          // استدعاء فوري للحصول على آخر حالة الطاولات
          _refreshStatusImmediately(floorId);
          // بدء الـ stream بعد تحميل الطاولات بنجاح
          _startStatusStream(floorId);
        },
      );
    } catch (e) {
      _state.value = TablesViewState.error('خطأ غير متوقع: $e');
    }
  }

  Future<void> refreshTables() async {
    if (selectedFloorId.value != null) {
      await loadTables(selectedFloorId.value!);
    }
  }

  // اختيار طاولة
  void selectTable(TableEntity table) {
    // يمكن إضافة منطق اختيار الطاولة هنا
    Get.snackbar('تم الاختيار', 'تم اختيار الطاولة: ${table.nameAr}');
  }

  // تصفية الطاولات حسب الحالة
  List<TableEntity> getTablesByStatus(int status) {
    return tables.where((table) => table.status == status).toList();
  }

  // تصفية الطاولات المتاحة (خضراء)
  List<TableEntity> getAvailableTables() {
    return getTablesByStatus(1); // status = 1 يعني متاحة
  }

  // تصفية الطاولات المشغولة
  List<TableEntity> getOccupiedTables() {
    return tables.where((table) => table.status != 1).toList();
  }

  // بدء stream لتحديث حالة الطاولات كل 90 ثانية
  void _startStatusStream(int floorId) {
    _stopStatusStream(); // إيقاف أي stream سابق

    // إنشاء stream يطلب الـ API كل 90 ثانية
    final stream = Stream.periodic(const Duration(seconds: 90), (_) => floorId)
        .asyncMap((floorId) async {
          try {
            final result = await _getTablesStatus(floorId);
            return result.fold(
              (failure) => <TableStatusEntity>[],
              (statusList) => statusList,
            );
          } catch (e) {
            // معالجة الأخطاء بصمت
            return <TableStatusEntity>[];
          }
        });

    _statusStreamSubscription = stream.listen(
      (statusList) {
        if (statusList.isNotEmpty) {
          _updateTablesStatus(statusList);
        }
      },
      onError: (error) {
        // معالجة الأخطاء بصمت - لا نريد إظهار أي شيء للمستخدم
      },
    );
  }

  // إيقاف stream تحديث الحالة
  void _stopStatusStream() {
    _statusStreamSubscription?.cancel();
    _statusStreamSubscription = null;
    _statusTimer?.cancel();
    _statusTimer = null;
  }

  // استدعاء فوري للحصول على آخر حالة الطاولات
  Future<void> _refreshStatusImmediately(int floorId) async {
    try {
      final result = await _getTablesStatus(floorId);
      result.fold(
        (failure) {
          // لا نعرض خطأ للمستخدم، فقط نتجاهل
        },
        (statusList) {
          if (statusList.isNotEmpty) {
            _updateTablesStatus(statusList);
          }
        },
      );
    } catch (e) {
      // معالجة الأخطاء بصمت
    }
  }

  // تحديث حالة طاولة محددة
  Future<void> refreshTableStatus(int tableId) async {
    if (selectedFloorId.value == null) return;
    
    try {
      final result = await _getTablesStatus(selectedFloorId.value!);
      result.fold(
        (failure) {
          // لا نعرض خطأ للمستخدم
        },
        (statusList) {
          if (statusList.isNotEmpty) {
            _updateTablesStatus(statusList);
          }
        },
      );
    } catch (e) {
      // معالجة الأخطاء بصمت
    }
  }

  // تحديث حالة الطاولات من البيانات المستلمة من الـ stream
  void _updateTablesStatus(List<TableStatusEntity> statusList) {
    // إنشاء map للبحث السريع - أكثر كفاءة
    final statusMap = <int, TableStatusEntity>{
      for (var status in statusList) status.tableId: status
    };

    // تحديث حالة الطاولات الموجودة
    bool hasChanges = false;
    final updatedTables = tables.map((table) {
      final status = statusMap[table.id];
      if (status != null) {
        // التحقق من وجود تغييرات قبل إنشاء كائن جديد
        if (table.status != status.status ||
            table.statusColor != status.color ||
            table.total != status.totalInvoice) {
          hasChanges = true;
          // إنشاء TableEntity محدث مع البيانات الجديدة
          return TableEntity(
            id: table.id,
            code: table.code,
            nameAr: table.nameAr,
            parentID: table.parentID,
            status: status.status,
            branchID: table.branchID,
            text: table.text,
            userName: table.userName,
            orderNo: table.orderNo,
            time: table.time,
            statusColor: status.color,
            total: status.totalInvoice,
          );
        }
      }
      return table;
    }).toList();

    // تحديث القائمة فقط إذا كانت هناك تغييرات
    if (hasChanges) {
      tables.value = updatedTables;
      // تحديث الـ state إذا كان في حالة success
      _state.value.maybeWhen(
        success: (_) {
          _state.value = TablesViewState.success(updatedTables);
        },
        orElse: () {},
      );
    }
  }

  @override
  void onClose() {
    _stopStatusStream();
    super.onClose();
  }
}

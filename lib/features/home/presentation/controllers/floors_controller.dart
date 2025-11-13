import 'package:get/get.dart';
import 'package:wafy/features/home/domain/entities/floor_entity.dart';
import 'package:wafy/features/home/domain/usecases/get_floors_usecase.dart';
import 'package:wafy/features/home/presentation/states/floors_view_state.dart';
import 'package:wafy/core/services/user_service.dart';
import 'package:wafy/features/home/presentation/controllers/tables_controller.dart';

class FloorsController extends GetxController {
  final GetFloors _getFloors;

  FloorsController(this._getFloors);

  final _state = const FloorsViewState.initial().obs;
  FloorsViewState get state => _state.value;

  var floors = <FloorEntity>[].obs;
  var selectedFloorId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadFloors();
  }

  Future<void> loadFloors() async {
    _state.value = const FloorsViewState.loading();

    try {
      // الحصول على المستخدم الحالي
      final userService = Get.find<UserService>();
      final currentUser = userService.currentUser;

      if (currentUser == null) {
        _state.value = const FloorsViewState.error(
          'لم يتم العثور على المستخدم',
        );
        return;
      }

      final result = await _getFloors(currentUser.id);

      result.fold(
        (failure) {
          _state.value = FloorsViewState.error(failure.message);
        },
        (floorsList) {
          floors.value = floorsList;
          _state.value = FloorsViewState.success(floorsList);

          // اختيار أول طابق تلقائياً بعد التحميل
          if (floorsList.isNotEmpty) {
            selectFloor(floorsList.first);
          }
        },
      );
    } catch (e) {
      _state.value = FloorsViewState.error('خطأ غير متوقع: $e');
    }
  }

  Future<void> refreshFloors() async {
    await loadFloors();
  }

  // اختيار طابق
  void selectFloor(FloorEntity floor) {
    selectedFloorId.value = floor.id;

    // تحميل طاولات الطابق المختار
    final tablesController = Get.find<TablesController>();
    tablesController.loadTables(floor.id);
  }
}

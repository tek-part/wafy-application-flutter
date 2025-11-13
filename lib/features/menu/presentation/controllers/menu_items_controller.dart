import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_items.dart';
import 'package:wafy/features/menu/presentation/states/menu_items_state.dart';

class MenuItemsController extends GetxController {
  final GetMenuItems _getMenuItems;

  MenuItemsController(this._getMenuItems);

  final _state = const MenuItemsState.initial().obs;
  MenuItemsState get state => _state.value;

  int? _currentCategoryId;

  Future<void> loadItems(int categoryId, {bool isRefresh = false}) async {
    _currentCategoryId = categoryId;
    _state.value = const MenuItemsState.loading();

    final result = await _getMenuItems(categoryId, isRefresh: isRefresh);
    result.fold(
      (failure) => _state.value = MenuItemsState.error(failure.message),
      (itemsList) {
        _state.value = MenuItemsState.success(itemsList);
      },
    );
  }

  Future<void> refreshItems() async {
    if (_currentCategoryId == null) return;
    await loadItems(_currentCategoryId!, isRefresh: true);
  }

  void clearItems() {
    _state.value = const MenuItemsState.initial();
    _currentCategoryId = null;
  }
}

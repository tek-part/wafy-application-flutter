import 'package:get/get.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';
import 'package:wafy/features/menu/domain/usecases/get_menu_categories.dart';
import 'package:wafy/features/menu/presentation/states/menu_categories_state.dart';

class MenuCategoriesController extends GetxController {
  final GetMenuCategories _getMenuCategories;

  MenuCategoriesController(this._getMenuCategories);

  final _state = const MenuCategoriesState.initial().obs;
  MenuCategoriesState get state => _state.value;

  Future<void> loadCategories({bool isRefresh = false}) async {
    _state.value = const MenuCategoriesState.loading();
    print('Loading categories...');

    final result = await _getMenuCategories(isRefresh: isRefresh);
    result.fold(
      (failure) {
        print('Error loading categories: ${failure.message}');
        _state.value = MenuCategoriesState.error(failure.message);
      },
      (categoriesList) {
        print('Categories loaded: ${categoriesList.length}');
        _state.value = MenuCategoriesState.success(categoriesList);
      },
    );
  }

  Future<void> refreshCategories() async {
    await loadCategories(isRefresh: true);
  }
}

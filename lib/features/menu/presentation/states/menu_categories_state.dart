import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';

part 'menu_categories_state.freezed.dart';

@freezed
class MenuCategoriesState with _$MenuCategoriesState {
  const factory MenuCategoriesState.initial() = _Initial;
  const factory MenuCategoriesState.loading() = _Loading;
  const factory MenuCategoriesState.success(List<MenuCategory> categories) =
      _Success;
  const factory MenuCategoriesState.error(String message) = _Error;
}

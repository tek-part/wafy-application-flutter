import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';

part 'menu_items_state.freezed.dart';

@freezed
class MenuItemsState with _$MenuItemsState {
  const factory MenuItemsState.initial() = _Initial;
  const factory MenuItemsState.loading() = _Loading;
  const factory MenuItemsState.success(List<MenuItem> items) = _Success;
  const factory MenuItemsState.error(String message) = _Error;
}

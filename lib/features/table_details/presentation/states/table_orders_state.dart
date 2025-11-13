import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/table_order_item.dart';

part 'table_orders_state.freezed.dart';

@freezed
class TableOrdersState with _$TableOrdersState {
  const factory TableOrdersState.initial() = _Initial;
  const factory TableOrdersState.loading() = _Loading;
  const factory TableOrdersState.success(List<TableOrderItem> orders) = _Success;
  const factory TableOrdersState.error(String message) = _Error;
}


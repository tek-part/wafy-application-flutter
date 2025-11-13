import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/table_entity.dart';

part 'tables_view_state.freezed.dart';

@freezed
class TablesViewState with _$TablesViewState {
  const factory TablesViewState.initial() = _Initial;
  const factory TablesViewState.loading() = _Loading;
  const factory TablesViewState.success(List<TableEntity> tables) = _Success;
  const factory TablesViewState.error(String message) = _Error;
}

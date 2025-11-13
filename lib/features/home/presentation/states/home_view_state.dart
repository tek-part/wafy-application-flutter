import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/table_entity.dart';

part 'home_view_state.freezed.dart';

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState.initial() = _Initial;
  const factory HomeViewState.loading() = _Loading;
  const factory HomeViewState.floorsLoaded(List<FloorEntity> floors) =
      _FloorsLoaded;
  const factory HomeViewState.tablesLoaded(List<TableEntity> tables) =
      _TablesLoaded;
  const factory HomeViewState.error(String message) = _Error;
}

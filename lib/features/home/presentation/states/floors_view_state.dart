import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/floor_entity.dart';

part 'floors_view_state.freezed.dart';

@freezed
class FloorsViewState with _$FloorsViewState {
  const factory FloorsViewState.initial() = _Initial;
  const factory FloorsViewState.loading() = _Loading;
  const factory FloorsViewState.success(List<FloorEntity> floors) = _Success;
  const factory FloorsViewState.error(String message) = _Error;
}

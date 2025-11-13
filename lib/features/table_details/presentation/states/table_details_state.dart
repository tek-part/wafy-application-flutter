import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wafy/features/home/domain/entities/table_entity.dart';

part 'table_details_state.freezed.dart';

@freezed
class TableDetailsState with _$TableDetailsState {
  const factory TableDetailsState.initial() = _Initial;
  const factory TableDetailsState.loading() = _Loading;
  const factory TableDetailsState.success(TableEntity table) = _Success;
  const factory TableDetailsState.error(String message) = _Error;
}


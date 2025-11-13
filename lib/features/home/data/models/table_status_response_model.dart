import 'table_status_model.dart';

class TableStatusResponseModel {
  final bool success;
  final List<TableStatusModel> data;

  const TableStatusResponseModel({required this.success, required this.data});

  factory TableStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return TableStatusResponseModel(
      success: json['success'] as bool? ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    TableStatusModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

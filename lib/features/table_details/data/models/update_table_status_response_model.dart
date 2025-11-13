class UpdateTableStatusResponseModel {
  final bool success;
  final String message;
  final int tableId;
  final String tableName;
  final int oldStatus;
  final String oldStatusName;
  final int newStatus;
  final String newStatusName;

  const UpdateTableStatusResponseModel({
    required this.success,
    required this.message,
    required this.tableId,
    required this.tableName,
    required this.oldStatus,
    required this.oldStatusName,
    required this.newStatus,
    required this.newStatusName,
  });

  factory UpdateTableStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateTableStatusResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      tableId: json['tableId'] as int? ?? 0,
      tableName: json['tableName'] as String? ?? '',
      oldStatus: json['oldStatus'] as int? ?? 0,
      oldStatusName: json['oldStatusName'] as String? ?? '',
      newStatus: json['newStatus'] as int? ?? 0,
      newStatusName: json['newStatusName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'tableId': tableId,
      'tableName': tableName,
      'oldStatus': oldStatus,
      'oldStatusName': oldStatusName,
      'newStatus': newStatus,
      'newStatusName': newStatusName,
    };
  }
}

class TableStatusModel {
  final int tableId;
  final int status;
  final String statusName;
  final double totalInvoice;
  final String color;

  const TableStatusModel({
    required this.tableId,
    required this.status,
    required this.statusName,
    required this.totalInvoice,
    required this.color,
  });

  factory TableStatusModel.fromJson(Map<String, dynamic> json) {
    return TableStatusModel(
      tableId: json['tableId'] as int,
      status: json['status'] as int,
      statusName: json['statusName'] as String,
      totalInvoice: (json['totalInvoice'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'status': status,
      'statusName': statusName,
      'totalInvoice': totalInvoice,
      'color': color,
    };
  }
}

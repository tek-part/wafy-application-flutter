class TableStatusEntity {
  final int tableId;
  final int status;
  final String statusName;
  final double totalInvoice;
  final String color;

  const TableStatusEntity({
    required this.tableId,
    required this.status,
    required this.statusName,
    required this.totalInvoice,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableStatusEntity &&
        other.tableId == tableId &&
        other.status == status &&
        other.statusName == statusName &&
        other.totalInvoice == totalInvoice &&
        other.color == color;
  }

  @override
  int get hashCode {
    return tableId.hashCode ^
        status.hashCode ^
        statusName.hashCode ^
        totalInvoice.hashCode ^
        color.hashCode;
  }

  @override
  String toString() {
    return 'TableStatusEntity(tableId: $tableId, status: $status, statusName: $statusName, totalInvoice: $totalInvoice, color: $color)';
  }
}

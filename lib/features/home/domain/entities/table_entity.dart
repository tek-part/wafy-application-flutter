class TableEntity {
  final int id;
  final int code;
  final String nameAr;
  final int parentID;
  final int status;
  final int branchID;
  final String text;
  final String? userName;
  final String? orderNo;
  final String time;
  final String statusColor;
  final double total;

  const TableEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.parentID,
    required this.status,
    required this.branchID,
    required this.text,
    this.userName,
    this.orderNo,
    required this.time,
    required this.statusColor,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableEntity &&
        other.id == id &&
        other.code == code &&
        other.nameAr == nameAr &&
        other.parentID == parentID &&
        other.status == status &&
        other.branchID == branchID &&
        other.text == text &&
        other.userName == userName &&
        other.orderNo == orderNo &&
        other.time == time &&
        other.statusColor == statusColor &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        nameAr.hashCode ^
        parentID.hashCode ^
        status.hashCode ^
        branchID.hashCode ^
        text.hashCode ^
        userName.hashCode ^
        orderNo.hashCode ^
        time.hashCode ^
        statusColor.hashCode ^
        total.hashCode;
  }

  @override
  String toString() {
    return 'TableEntity(id: $id, code: $code, nameAr: $nameAr, parentID: $parentID, status: $status, branchID: $branchID, text: $text, userName: $userName, orderNo: $orderNo, time: $time, statusColor: $statusColor, total: $total)';
  }
}


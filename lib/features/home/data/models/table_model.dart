import '../../domain/entities/table_entity.dart';

class TableModel extends TableEntity {
  const TableModel({
    required super.id,
    required super.code,
    required super.nameAr,
    required super.parentID,
    required super.status,
    required super.branchID,
    required super.text,
    super.userName,
    super.orderNo,
    required super.time,
    required super.statusColor,
    required super.total,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as int,
      code: json['code'] as int,
      nameAr: json['nameAr'] as String,
      parentID: json['parentID'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      branchID: json['branchID'] as int? ?? 0,
      text: json['text'] as String,
      userName: json['userName'] as String?,
      orderNo: json['orderNo'] as String?,
      time: json['time'] as String? ?? '',
      statusColor: json['statusColor'] as String,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nameAr': nameAr,
      'parentID': parentID,
      'status': status,
      'branchID': branchID,
      'text': text,
      'userName': userName,
      'orderNo': orderNo,
      'time': time,
      'statusColor': statusColor,
      'total': total,
    };
  }

  factory TableModel.fromEntity(TableEntity entity) {
    return TableModel(
      id: entity.id,
      code: entity.code,
      nameAr: entity.nameAr,
      parentID: entity.parentID,
      status: entity.status,
      branchID: entity.branchID,
      text: entity.text,
      userName: entity.userName,
      orderNo: entity.orderNo,
      time: entity.time,
      statusColor: entity.statusColor,
      total: entity.total,
    );
  }

  TableEntity toEntity() {
    return TableEntity(
      id: id,
      code: code,
      nameAr: nameAr,
      parentID: parentID,
      status: status,
      branchID: branchID,
      text: text,
      userName: userName,
      orderNo: orderNo,
      time: time,
      statusColor: statusColor,
      total: total,
    );
  }
}

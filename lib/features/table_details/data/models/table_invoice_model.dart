import '../../domain/entities/table_invoice.dart';
import 'table_order_item_model.dart';

class TableInvoiceModel extends TableInvoice {
  const TableInvoiceModel({
    required super.id,
    required super.tableId,
    required super.tableName,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.createdAt,
    super.orderNumber,
  });

  factory TableInvoiceModel.fromJson(Map<String, dynamic> json) {
    return TableInvoiceModel(
      id: json['id'] as int,
      tableId: json['tableId'] as int,
      tableName: json['tableName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => TableOrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderNumber: json['orderNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,
      'tableName': tableName,
      'items': items.map((item) {
        if (item is TableOrderItemModel) {
          return item.toJson();
        }
        return TableOrderItemModel.fromEntity(item).toJson();
      }).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'orderNumber': orderNumber,
    };
  }

  factory TableInvoiceModel.fromEntity(TableInvoice entity) {
    return TableInvoiceModel(
      id: entity.id,
      tableId: entity.tableId,
      tableName: entity.tableName,
      items: entity.items,
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      createdAt: entity.createdAt,
      orderNumber: entity.orderNumber,
    );
  }

  TableInvoice toEntity() {
    return TableInvoice(
      id: id,
      tableId: tableId,
      tableName: tableName,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      createdAt: createdAt,
      orderNumber: orderNumber,
    );
  }
}


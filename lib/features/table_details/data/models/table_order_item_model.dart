import '../../domain/entities/table_order_item.dart';

class TableOrderItemModel extends TableOrderItem {
  const TableOrderItemModel({
    required super.id,
    required super.tableId,
    required super.menuItemId,
    required super.itemName,
    required super.price,
    required super.quantity,
    super.size,
    super.notes,
    required super.createdAt,
  });

  factory TableOrderItemModel.fromJson(Map<String, dynamic> json) {
    return TableOrderItemModel(
      id: json['id'] as int,
      tableId: json['tableId'] as int,
      menuItemId: json['menuItemId'] as int,
      itemName: json['itemName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      size: json['size'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,
      'menuItemId': menuItemId,
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'size': size,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TableOrderItemModel.fromEntity(TableOrderItem entity) {
    return TableOrderItemModel(
      id: entity.id,
      tableId: entity.tableId,
      menuItemId: entity.menuItemId,
      itemName: entity.itemName,
      price: entity.price,
      quantity: entity.quantity,
      size: entity.size,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  TableOrderItem toEntity() {
    return TableOrderItem(
      id: id,
      tableId: tableId,
      menuItemId: menuItemId,
      itemName: itemName,
      price: price,
      quantity: quantity,
      size: size,
      notes: notes,
      createdAt: createdAt,
    );
  }
}


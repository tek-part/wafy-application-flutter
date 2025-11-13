import 'package:equatable/equatable.dart';

class TableOrderItem extends Equatable {
  final int id;
  final int tableId;
  final int menuItemId;
  final String itemName;
  final double price;
  final int quantity;
  final String? size;
  final String? notes;
  final DateTime createdAt;

  const TableOrderItem({
    required this.id,
    required this.tableId,
    required this.menuItemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.size,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        tableId,
        menuItemId,
        itemName,
        price,
        quantity,
        size,
        notes,
        createdAt,
      ];

  double get totalPrice => price * quantity;
}


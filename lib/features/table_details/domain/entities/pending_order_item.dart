import 'package:equatable/equatable.dart';

class PendingOrderItem extends Equatable {
  final int menuItemId;
  final String itemName;
  final double price;
  final int quantity;
  final int? itemSizeId;
  final String? sizeName;
  final String? notes;

  const PendingOrderItem({
    required this.menuItemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.itemSizeId,
    this.sizeName,
    this.notes,
  });

  @override
  List<Object?> get props => [
        menuItemId,
        itemName,
        price,
        quantity,
        itemSizeId,
        sizeName,
        notes,
      ];

  double get totalPrice => price * quantity;
}


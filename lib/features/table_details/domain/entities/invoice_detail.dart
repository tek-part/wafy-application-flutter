import 'package:equatable/equatable.dart';

class InvoiceDetail extends Equatable {
  final int itemId;
  final double quantity;
  final double price;
  final int? itemSizeId;
  final String? notice;
  // إضافة الحقول الجديدة من API response
  final String? itemName;
  final String? sizeName;
  final double? totalPrice;

  const InvoiceDetail({
    required this.itemId,
    required this.quantity,
    required this.price,
    this.itemSizeId,
    this.notice,
    this.itemName,
    this.sizeName,
    this.totalPrice,
  });

  @override
  List<Object?> get props => [
    itemId,
    quantity,
    price,
    itemSizeId,
    notice,
    itemName,
    sizeName,
    totalPrice,
  ];
}

import '../../domain/entities/invoice_detail.dart';

class InvoiceDetailModel extends InvoiceDetail {
  const InvoiceDetailModel({
    required super.itemId,
    required super.quantity,
    required super.price,
    super.itemSizeId,
    super.notice,
    super.itemName,
    super.sizeName,
    super.totalPrice,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailModel(
      itemId: json['itemId'] as int,
      // قراءة itemQuantity بدلاً من quantity
      quantity:
          (json['itemQuantity'] as num?)?.toDouble() ??
          (json['quantity'] as num).toDouble(),
      // قراءة itemPrice بدلاً من price
      price:
          (json['itemPrice'] as num?)?.toDouble() ??
          (json['price'] as num).toDouble(),
      itemSizeId: json['itemSizeId'] as int?,
      notice: json['notice'] as String?,
      // قراءة itemName مباشرة من API
      itemName: json['itemName'] as String?,
      // قراءة sizeName مباشرة من API
      sizeName: json['sizeName'] as String?,
      // قراءة totalPrice من API
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'price': price,
      if (itemSizeId != null) 'itemSizeId': itemSizeId,
      if (notice != null) 'notice': notice,
      if (itemName != null) 'itemName': itemName,
      if (sizeName != null) 'sizeName': sizeName,
      if (totalPrice != null) 'totalPrice': totalPrice,
    };
  }

  factory InvoiceDetailModel.fromEntity(InvoiceDetail entity) {
    return InvoiceDetailModel(
      itemId: entity.itemId,
      quantity: entity.quantity,
      price: entity.price,
      itemSizeId: entity.itemSizeId,
      notice: entity.notice,
      itemName: entity.itemName,
      sizeName: entity.sizeName,
      totalPrice: entity.totalPrice,
    );
  }

  InvoiceDetail toEntity() {
    return InvoiceDetail(
      itemId: itemId,
      quantity: quantity,
      price: price,
      itemSizeId: itemSizeId,
      notice: notice,
      itemName: itemName,
      sizeName: sizeName,
      totalPrice: totalPrice,
    );
  }
}

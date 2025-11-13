import '../../domain/entities/item_size.dart';

class ItemSizeModel extends ItemSize {
  const ItemSizeModel({
    required super.id,
    required super.sizeName,
    required super.sizeNameEN,
    required super.sizePrice,
  });

  factory ItemSizeModel.fromJson(Map<String, dynamic> json) {
    return ItemSizeModel(
      id: json['id'] as int,
      sizeName: json['sizeName'] as String,
      sizeNameEN: json['sizeNameEN'] as String,
      sizePrice: (json['sizePrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sizeName': sizeName,
      'sizeNameEN': sizeNameEN,
      'sizePrice': sizePrice,
    };
  }

  factory ItemSizeModel.fromEntity(ItemSize entity) {
    return ItemSizeModel(
      id: entity.id,
      sizeName: entity.sizeName,
      sizeNameEN: entity.sizeNameEN,
      sizePrice: entity.sizePrice,
    );
  }

  ItemSize toEntity() {
    return ItemSize(
      id: id,
      sizeName: sizeName,
      sizeNameEN: sizeNameEN,
      sizePrice: sizePrice,
    );
  }
}


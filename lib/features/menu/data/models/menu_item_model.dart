import 'package:json_annotation/json_annotation.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel extends MenuItem {
  @override
  @JsonKey(name: 'id')
  final int id;

  @override
  @JsonKey(name: 'nameAr')
  final String nameAr;

  @override
  @JsonKey(name: 'price')
  final double price;

  @override
  @JsonKey(name: 'itemImage')
  final String? itemImage;

  @override
  @JsonKey(name: 'ennAme')
  final String ennAme;

  @override
  @JsonKey(name: 'description')
  final String description;

  const MenuItemModel({
    required this.id,
    required this.nameAr,
    required this.price,
    this.itemImage,
    required this.ennAme,
    required this.description,
  }) : super(
         id: id,
         nameAr: nameAr,
         price: price,
         itemImage: itemImage,
         ennAme: ennAme,
         description: description,
       );

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MenuItemModelFromJson(json);
    } catch (e) {
      // Fallback for null safety
      return MenuItemModel(
        id: json['id'] as int? ?? 0,
        nameAr: json['nameAr'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        itemImage: json['itemImage'] as String?,
        ennAme: json['ennAme'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  factory MenuItemModel.fromEntity(MenuItem item) {
    return MenuItemModel(
      id: item.id,
      nameAr: item.nameAr,
      price: item.price,
      itemImage: item.itemImage,
      ennAme: item.ennAme,
      description: item.description,
    );
  }

  MenuItem toEntity() {
    return MenuItem(
      id: id,
      nameAr: nameAr,
      price: price,
      itemImage: itemImage,
      ennAme: ennAme,
      description: description,
    );
  }
}

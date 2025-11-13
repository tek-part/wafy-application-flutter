// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      price: (json['price'] as num).toDouble(),
      itemImage: json['itemImage'] as String?,
      ennAme: json['ennAme'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'price': instance.price,
      'itemImage': instance.itemImage,
      'ennAme': instance.ennAme,
      'description': instance.description,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuCategoryModel _$MenuCategoryModelFromJson(Map<String, dynamic> json) =>
    MenuCategoryModel(
      id: (json['id'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEN: json['nameEN'] as String,
      groupPhoto: json['groupPhoto'] as String?,
    );

Map<String, dynamic> _$MenuCategoryModelToJson(MenuCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEN': instance.nameEN,
      'groupPhoto': instance.groupPhoto,
    };

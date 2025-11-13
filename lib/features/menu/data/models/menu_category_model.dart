import 'package:json_annotation/json_annotation.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';

part 'menu_category_model.g.dart';

@JsonSerializable()
class MenuCategoryModel extends MenuCategory {
  @override
  @JsonKey(name: 'id')
  final int id;

  @override
  @JsonKey(name: 'nameAr')
  final String nameAr;

  @override
  @JsonKey(name: 'nameEN')
  final String nameEN;

  @override
  @JsonKey(name: 'groupPhoto')
  final String? groupPhoto;

  const MenuCategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEN,
    this.groupPhoto,
  }) : super(id: id, nameAr: nameAr, nameEN: nameEN, groupPhoto: groupPhoto);

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$MenuCategoryModelFromJson(json);
    } catch (e) {
      // Fallback for null safety
      return MenuCategoryModel(
        id: json['id'] as int? ?? 0,
        nameAr: json['nameAr'] as String? ?? '',
        nameEN: json['nameEN'] as String? ?? '',
        groupPhoto: json['groupPhoto'] as String?,
      );
    }
  }

  Map<String, dynamic> toJson() => _$MenuCategoryModelToJson(this);

  factory MenuCategoryModel.fromEntity(MenuCategory category) {
    return MenuCategoryModel(
      id: category.id,
      nameAr: category.nameAr,
      nameEN: category.nameEN,
      groupPhoto: category.groupPhoto,
    );
  }

  MenuCategory toEntity() {
    return MenuCategory(
      id: id,
      nameAr: nameAr,
      nameEN: nameEN,
      groupPhoto: groupPhoto,
    );
  }
}

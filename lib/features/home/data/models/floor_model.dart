import '../../domain/entities/floor_entity.dart';

class FloorModel extends FloorEntity {
  const FloorModel({
    required super.id,
    required super.code,
    required super.nameAr,
  });

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    return FloorModel(
      id: json['id'] as int,
      code: json['code'] as int,
      nameAr: json['nameAr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'nameAr': nameAr};
  }

  factory FloorModel.fromEntity(FloorEntity entity) {
    return FloorModel(id: entity.id, code: entity.code, nameAr: entity.nameAr);
  }

  FloorEntity toEntity() {
    return FloorEntity(id: id, code: code, nameAr: nameAr);
  }
}

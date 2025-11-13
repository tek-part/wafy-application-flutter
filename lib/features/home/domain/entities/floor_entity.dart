class FloorEntity {
  final int id;
  final int code;
  final String nameAr;

  const FloorEntity({
    required this.id,
    required this.code,
    required this.nameAr,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FloorEntity &&
        other.id == id &&
        other.code == code &&
        other.nameAr == nameAr;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ nameAr.hashCode;

  @override
  String toString() {
    return 'FloorEntity(id: $id, code: $code, nameAr: $nameAr)';
  }
}


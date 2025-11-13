import 'package:equatable/equatable.dart';

class MenuCategory extends Equatable {
  final int id;
  final String nameAr;
  final String nameEN;
  final String? groupPhoto;

  const MenuCategory({
    required this.id,
    required this.nameAr,
    required this.nameEN,
    this.groupPhoto,
  });

  @override
  List<Object?> get props => [id, nameAr, nameEN, groupPhoto];
}

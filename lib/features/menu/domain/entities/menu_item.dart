import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final String nameAr;
  final double price;
  final String? itemImage;
  final String ennAme;
  final String description;

  const MenuItem({
    required this.id,
    required this.nameAr,
    required this.price,
    this.itemImage,
    required this.ennAme,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    nameAr,
    price,
    itemImage,
    ennAme,
    description,
  ];
}

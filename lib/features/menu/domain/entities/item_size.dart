import 'package:equatable/equatable.dart';

class ItemSize extends Equatable {
  final int id;
  final String sizeName;
  final String sizeNameEN;
  final double sizePrice;

  const ItemSize({
    required this.id,
    required this.sizeName,
    required this.sizeNameEN,
    required this.sizePrice,
  });

  @override
  List<Object?> get props => [id, sizeName, sizeNameEN, sizePrice];
}


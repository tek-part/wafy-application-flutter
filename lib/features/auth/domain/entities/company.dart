import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final int id;
  final String companyNameAr;
  final String loGo;

  const Company({
    required this.id,
    required this.companyNameAr,
    required this.loGo,
  });

  @override
  List<Object?> get props => [id, companyNameAr, loGo];
}

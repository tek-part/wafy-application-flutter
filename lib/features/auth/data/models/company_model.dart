import 'package:json_annotation/json_annotation.dart';
import 'package:wafy/features/auth/domain/entities/company.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel extends Company {
  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'companyNameAr')
  final String companyNameAr;
  @override
  @JsonKey(name: 'loGo')
  final String loGo;
  const CompanyModel({
    required this.id,
    required this.companyNameAr,
    required this.loGo,
  }) : super(id: id, companyNameAr: companyNameAr, loGo: loGo);

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$CompanyModelFromJson(json);
    } catch (e) {
      // Fallback for null safety
      return CompanyModel(
        id: json['id'] as int? ?? 0,
        companyNameAr:
            json['companyNameAr'] as String? ??
            json['company_name_ar'] as String? ??
            '',
        loGo: json['loGo'] as String? ?? json['logo'] as String? ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  factory CompanyModel.fromEntity(Company company) {
    return CompanyModel(
      id: company.id,
      companyNameAr: company.companyNameAr,
      loGo: company.loGo,
    );
  }

  Company toEntity() {
    return Company(id: id, companyNameAr: companyNameAr, loGo: loGo);
  }
}

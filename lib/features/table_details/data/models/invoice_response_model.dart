import 'invoice_main_model.dart';
import 'invoice_detail_model.dart';

class InvoiceResponseModel {
  final InvoiceMainModel invoiceMain;
  final List<InvoiceDetailModel> details;

  const InvoiceResponseModel({
    required this.invoiceMain,
    required this.details,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoiceResponseModel(
      invoiceMain: InvoiceMainModel.fromJson(
        json['invoiceMain'] as Map<String, dynamic>,
      ),
      details: (json['details'] as List<dynamic>)
          .map((detail) => InvoiceDetailModel.fromJson(
                detail as Map<String, dynamic>,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceMain': invoiceMain.toJson(),
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}


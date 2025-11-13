import 'invoice_main_model.dart';
import 'invoice_detail_model.dart';

class InvoiceRequestModel {
  final InvoiceMainModel invoiceMain;
  final List<InvoiceDetailModel> details;

  const InvoiceRequestModel({
    required this.invoiceMain,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceMain': invoiceMain.toJson(),
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}


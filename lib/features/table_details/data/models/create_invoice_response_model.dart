class CreateInvoiceResponseModel {
  final String message;
  final int invoiceId;

  const CreateInvoiceResponseModel({
    required this.message,
    required this.invoiceId,
  });

  factory CreateInvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateInvoiceResponseModel(
      message: json['message'] as String,
      invoiceId: json['invoiceId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'invoiceId': invoiceId,
    };
  }
}


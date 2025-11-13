import '../../domain/entities/invoice_main.dart';

class InvoiceMainModel extends InvoiceMain {
  const InvoiceMainModel({
    super.invoiceId,
    required super.rstableId,
    required super.userId,
    super.totalInvoice,
  });

  factory InvoiceMainModel.fromJson(Map<String, dynamic> json) {
    return InvoiceMainModel(
      invoiceId: json['invoiceId'] as int?,
      rstableId: json['rstableId'] as int,
      userId: json['userId'] as int,
      // قراءة totalIvoice (مع typo) من API
      totalInvoice:
          (json['totalIvoice'] as num?)?.toDouble() ??
          (json['totalInvoice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (invoiceId != null) 'invoiceId': invoiceId,
      'rstableId': rstableId,
      'userId': userId,
      if (totalInvoice != null) 'totalInvoice': totalInvoice,
    };
  }

  factory InvoiceMainModel.fromEntity(InvoiceMain entity) {
    return InvoiceMainModel(
      invoiceId: entity.invoiceId,
      rstableId: entity.rstableId,
      userId: entity.userId,
      totalInvoice: entity.totalInvoice,
    );
  }

  InvoiceMain toEntity() {
    return InvoiceMain(
      invoiceId: invoiceId,
      rstableId: rstableId,
      userId: userId,
      totalInvoice: totalInvoice,
    );
  }
}

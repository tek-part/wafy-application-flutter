import 'package:equatable/equatable.dart';

class InvoiceMain extends Equatable {
  final int? invoiceId;
  final int rstableId;
  final int userId;
  // إضافة totalInvoice من API response
  final double? totalInvoice;

  const InvoiceMain({
    this.invoiceId,
    required this.rstableId,
    required this.userId,
    this.totalInvoice,
  });

  @override
  List<Object?> get props => [invoiceId, rstableId, userId, totalInvoice];
}

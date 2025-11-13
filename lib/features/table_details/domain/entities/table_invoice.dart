import 'package:equatable/equatable.dart';
import 'table_order_item.dart';

class TableInvoice extends Equatable {
  final int id;
  final int tableId;
  final String tableName;
  final List<TableOrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final DateTime createdAt;
  final String? orderNumber;

  const TableInvoice({
    required this.id,
    required this.tableId,
    required this.tableName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.createdAt,
    this.orderNumber,
  });

  @override
  List<Object?> get props => [
        id,
        tableId,
        tableName,
        items,
        subtotal,
        tax,
        total,
        createdAt,
        orderNumber,
      ];
}


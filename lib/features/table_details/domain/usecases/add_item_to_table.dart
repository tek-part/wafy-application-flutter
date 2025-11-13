import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_order_item.dart';
import '../repositories/table_details_repository.dart';

class AddItemToTable {
  final TableDetailsRepository repository;

  AddItemToTable(this.repository);

  Future<Either<Failure, TableOrderItem>> call({
    required int tableId,
    required int menuItemId,
    required int quantity,
    String? size,
    String? notes,
  }) async {
    return await repository.addItemToTable(
      tableId: tableId,
      menuItemId: menuItemId,
      quantity: quantity,
      size: size,
      notes: notes,
    );
  }
}


import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/table_order_item.dart';
import '../repositories/table_details_repository.dart';

class GetTableOrders {
  final TableDetailsRepository repository;

  GetTableOrders(this.repository);

  Future<Either<Failure, List<TableOrderItem>>> call(int tableId) async {
    return await repository.getTableOrders(tableId);
  }
}


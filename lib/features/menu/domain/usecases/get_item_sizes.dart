import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../entities/item_size.dart';
import '../repositories/menu_repository.dart';

class GetItemSizes {
  final MenuRepository repository;

  GetItemSizes(this.repository);

  Future<Either<Failure, List<ItemSize>>> call(int itemId) async {
    return await repository.getItemSizes(itemId);
  }
}


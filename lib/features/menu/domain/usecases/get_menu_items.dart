import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/menu/domain/entities/menu_item.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItems {
  final MenuRepository repository;

  GetMenuItems(this.repository);

  Future<Either<Failure, List<MenuItem>>> call(
    int categoryId, {
    bool isRefresh = false,
  }) async {
    return await repository.getMenuItems(categoryId, isRefresh: isRefresh);
  }
}

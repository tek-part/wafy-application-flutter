import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/menu/domain/entities/menu_category.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

class GetMenuCategories {
  final MenuRepository repository;

  GetMenuCategories(this.repository);

  Future<Either<Failure, List<MenuCategory>>> call({
    bool isRefresh = false,
  }) async {
    return await repository.getMenuCategories(isRefresh: isRefresh);
  }
}

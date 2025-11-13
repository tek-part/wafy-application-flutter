import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/menu/domain/repositories/menu_repository.dart';

class RefreshMenuData {
  final MenuRepository repository;

  RefreshMenuData(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.refreshMenuData();
  }
}

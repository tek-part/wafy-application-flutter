import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/failures.dart';
import '../repositories/menu_repository.dart';

class PreloadMenuData {
  final MenuRepository repository;

  PreloadMenuData(this.repository);

  Future<Either<Failure, Unit>> call({
    void Function(double progress, String message)? onProgress,
  }) async {
    return await repository.preloadMenuData(onProgress: onProgress);
  }
}

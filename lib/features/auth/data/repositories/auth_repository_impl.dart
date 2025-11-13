import 'package:dartz/dartz.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/core/error/failures.dart';
import 'package:wafy/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wafy/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wafy/features/auth/domain/entities/company.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<User>>> getAllUsers({
    bool isRefresh = true,
  }) async {
    try {
      if (isRefresh) {
        final userModels = await remoteDataSource.getAllUsers();
        final users = userModels.map((model) => model.toEntity()).toList();
        await localDataSource.cacheAllUsers(userModels);
        return Right(users);
      } else {
        // جلب المستخدمين من الـ cache أولاً
        try {
          final cachedUsers = await localDataSource.getCachedAllUsers();
          return Right(cachedUsers.map((model) => model.toEntity()).toList());
        } on CacheException {
          // إذا لم توجد بيانات في الـ cache، جلب من API
          final userModels = await remoteDataSource.getAllUsers();
          final users = userModels.map((model) => model.toEntity()).toList();

          // حفظ المستخدمين في الـ cache
          await localDataSource.cacheAllUsers(userModels);

          return Right(users);
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> login(String password) async {
    try {
      // جلب كل المستخدمين من API
      final userModels = await remoteDataSource.getAllUsers();

      // البحث عن المستخدم المطابق لكلمة المرور
      final matchingUser = userModels.firstWhere(
        (user) => user.password == password,
        orElse: () => throw const ValidationException('كلمة المرور غير صحيحة'),
      );

      // حفظ المستخدم محلياً
      await localDataSource.cacheUser(matchingUser);

      return Right(matchingUser.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompInfo({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        final companyModel = await remoteDataSource.getCompInfo();
        await localDataSource.cacheCompanyInfo(companyModel);
        return Right(companyModel.toEntity());
      } else {
        // جلب معلومات الشركة من الـ cache أولاً
        try {
          final cachedCompany = await localDataSource.getCachedCompanyInfo();
          return Right(cachedCompany.toEntity());
        } on CacheException {
          // إذا لم توجد بيانات في الـ cache، جلب من API
          final companyModel = await remoteDataSource.getCompInfo();

          // حفظ معلومات الشركة في الـ cache
          await localDataSource.cacheCompanyInfo(companyModel);

          return Right(companyModel.toEntity());
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wafy/core/error/exceptions.dart';
import 'package:wafy/features/auth/data/models/company_model.dart';
import 'package:wafy/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAllUsers(List<UserModel> users);
  Future<List<UserModel>> getCachedAllUsers();
  Future<void> clearAllUsers();
  Future<void> cacheCompanyInfo(CompanyModel company);
  Future<CompanyModel> getCachedCompanyInfo();
  Future<void> clearCompanyInfo();
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box authBox;
  static const String CACHED_USER_KEY = 'CACHED_USER';
  static const String CACHED_COMPANY_INFO_KEY = 'CACHED_COMPANY_INFO';
  static const String CACHED_ALL_USERS_KEY = 'CACHED_ALL_USERS';
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.authBox,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(CACHED_USER_KEY, userJson);
    } catch (e) {
      throw CacheException('فشل في حفظ بيانات المستخدم: $e');
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(CACHED_USER_KEY);
      if (userJson == null) {
        throw const CacheException('لا يوجد مستخدم محفوظ');
      }
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('فشل في جلب بيانات المستخدم: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(CACHED_USER_KEY);
    } catch (e) {
      throw CacheException('فشل في مسح بيانات المستخدم: $e');
    }
  }

  //company info
  @override
  Future<void> cacheCompanyInfo(CompanyModel company) async {
    try {
      final companyJson = json.encode(company.toJson());
      await authBox.put(CACHED_COMPANY_INFO_KEY, companyJson);
    } catch (e) {
      throw CacheException('فشل في حفظ بيانات الشركة: $e');
    }
  }

  @override
  Future<CompanyModel> getCachedCompanyInfo() async {
    try {
      final companyJson = authBox.get(CACHED_COMPANY_INFO_KEY);
      if (companyJson == null) {
        throw const CacheException('لا يوجد معلومات الشركة محفوظة');
      }
      final companyMap = json.decode(companyJson) as Map<String, dynamic>;
      return CompanyModel.fromJson(companyMap);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('فشل في جلب بيانات الشركة: $e');
    }
  }

  @override
  Future<void> clearCompanyInfo() async {
    try {
      await authBox.delete(CACHED_COMPANY_INFO_KEY);
    } catch (e) {
      throw CacheException('فشل في مسح بيانات الشركة: $e');
    }
  }

  //all users
  @override
  Future<void> cacheAllUsers(List<UserModel> users) async {
    try {
      final usersJson = json.encode(
        users.map((user) => user.toJson()).toList(),
      );
      await authBox.put(CACHED_ALL_USERS_KEY, usersJson);
    } catch (e) {
      throw CacheException('فشل في حفظ بيانات المستخدمين: $e');
    }
  }

  @override
  Future<List<UserModel>> getCachedAllUsers() async {
    try {
      final usersJson = authBox.get(CACHED_ALL_USERS_KEY);
      if (usersJson == null) {
        throw const CacheException('لا يوجد مستخدمين محفوظين');
      }
      final usersList = json.decode(usersJson) as List<dynamic>;
      return usersList
          .map((userMap) => UserModel.fromJson(userMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('فشل في جلب بيانات المستخدمين: $e');
    }
  }

  @override
  Future<void> clearAllUsers() async {
    try {
      await authBox.delete(CACHED_ALL_USERS_KEY);
    } catch (e) {
      throw CacheException('فشل في مسح بيانات المستخدمين: $e');
    }
  }
}

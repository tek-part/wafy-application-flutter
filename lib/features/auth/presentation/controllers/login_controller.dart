import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/features/auth/domain/entities/company.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/usecases/get_all_users.dart';
import 'package:wafy/features/auth/domain/usecases/get_comp_info.dart';
import 'package:wafy/features/auth/domain/usecases/login.dart';
import 'package:wafy/features/auth/presentation/states/login_state.dart';
import 'package:wafy/core/services/user_service.dart';
import 'package:wafy/core/error/failures.dart';

class LoginController extends GetxController {
  final GetAllUsers _getAllUsers;
  final GetCompInfo _getCompInfo;
  final Login _login;

  LoginController(this._getAllUsers, this._getCompInfo, this._login);

  final TextEditingController passwordController = TextEditingController();
  final _state = const LoginState.initial().obs;
  LoginState get state => _state.value;

  var users = <User>[].obs;
  var companyInfo = Rxn<Company>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData({bool isRefresh = false}) async {
    _state.value = const LoginState.loading();

    try {
      // جلب المستخدمين
      final usersResult = await _getAllUsers(isRefresh: isRefresh);
      final companyResult = await _getCompInfo(isRefresh: isRefresh);

      bool hasError = false;
      String? errorMessage;

      // معالجة نتيجة المستخدمين
      usersResult.fold(
        (failure) {
          // في حالة خطأ الشبكة، لا نعتبره خطأ قاتل
          if (failure is! NetworkFailure) {
            hasError = true;
            errorMessage = failure.message;
          }
        },
        (users) {
          this.users.value = users;
        },
      );

      // معالجة نتيجة معلومات الشركة
      companyResult.fold(
        (failure) {
          // في حالة خطأ الشبكة، لا نعتبره خطأ قاتل
          if (failure is! NetworkFailure) {
            hasError = true;
            errorMessage = errorMessage ?? failure.message;
          }
        },
        (company) {
          companyInfo.value = company;
        },
      );

      // تعيين الحالة النهائية
      if (hasError) {
        _state.value = LoginState.error(errorMessage ?? 'حدث خطأ غير متوقع');
      } else {
        _state.value = const LoginState.initial();
      }
    } catch (e) {
      // في حالة خطأ غير متوقع، لا نعرض رسالة خطأ قاتلة
      _state.value = const LoginState.initial();
    }
  }

  Future<void> login() async {
    if (passwordController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال كلمة المرور');
      return;
    }

    // التحقق من وجود المستخدمين
    if (users.isEmpty) {
      Get.snackbar('خطأ', 'لم يتم تحميل المستخدمين، يرجى المحاولة مرة أخرى');
      return;
    }

    _state.value = const LoginState.loading();

    final userIndex = users.indexWhere(
      (user) => user.password == passwordController.text,
    );

    if (userIndex == -1) {
      _state.value = const LoginState.initial();
      Get.snackbar('خطأ', 'كلمة المرور غير صحيحة');
      return;
    }

    final currentUser = users[userIndex];

    // استخدام Login use case لحفظ المستخدم
    final result = await _login(currentUser.password);

    result.fold(
      (failure) {
        _state.value = LoginState.error(failure.message);
      },
      (user) {
        // تعيين المستخدم في UserService
        final userService = Get.find<UserService>();
        userService.setCurrentUser(user);

        _state.value = LoginState.success(user);
        Get.offAllNamed(Routes.home);
      },
    );
  }

  // refresh data
  Future<void> refreshData() async {
    await loadData(isRefresh: true);
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}

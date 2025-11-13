import 'package:get/get.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';
import 'package:wafy/features/auth/domain/usecases/get_current_user.dart';

class UserService extends GetxService {
  final GetCurrentUser _getCurrentUser;

  UserService(this._getCurrentUser);

  // Reactive current user
  final _currentUser = Rxn<User>();
  User? get currentUser => _currentUser.value;

  // Reactive stream للمستخدم
  Stream<User?> get userStream => _currentUser.stream;

  // التحقق من تسجيل الدخول
  bool get isLoggedIn => _currentUser.value != null;

  // تعيين المستخدم الحالي
  void setCurrentUser(User user) {
    _currentUser.value = user;
  }

  // مسح المستخدم الحالي
  void clearCurrentUser() {
    _currentUser.value = null;
  }

  // تحميل المستخدم من الـ cache عند بدء التطبيق
  Future<void> loadCurrentUser() async {
    final result = await _getCurrentUser();
    result.fold(
      (failure) {
        _currentUser.value = null;
      },
      (user) {
        _currentUser.value = user;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    // تحميل المستخدم عند تهيئة الـ service
    loadCurrentUser();
  }
}

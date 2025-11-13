import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wafy/features/auth/domain/entities/user.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading; // Single loading state
  const factory LoginState.success(User user) = _Success;
  const factory LoginState.error(String message) = _Error;
}

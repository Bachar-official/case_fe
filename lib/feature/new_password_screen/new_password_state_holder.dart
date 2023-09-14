import 'package:case_fe/feature/new_password_screen/new_password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPasswordStateHolder extends StateNotifier<NewPasswordState> {
  NewPasswordStateHolder() : super(const NewPasswordState.initial());

  NewPasswordState get newPasswordState => state;

  void setOldPassword(String oldPassword) {
    state = state.copyWith(oldPassword: oldPassword);
  }

  void setNewPassword(String newPassword) {
    state = state.copyWith(newPassword: newPassword);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmNewPassword: confirmPassword);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

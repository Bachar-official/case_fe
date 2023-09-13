import 'package:case_fe/feature/login_screen/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginStateHolder extends StateNotifier<LoginState> {
  LoginStateHolder() : super(const LoginState.initial());

  LoginState get loginState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void clearUserName() {
    state = state.copyWith(username: '');
  }

  void clearPassword() {
    state = state.copyWith(password: '');
  }
}

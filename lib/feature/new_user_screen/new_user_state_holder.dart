import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/new_user_screen/new_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewUserStateHolder extends StateNotifier<NewUserState> {
  NewUserStateHolder() : super(const NewUserState.initial());

  NewUserState get newUserState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setPermission(Permission permission) {
    state = state.copyWith(permission: permission);
  }
}

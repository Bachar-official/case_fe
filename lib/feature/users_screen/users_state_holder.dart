import 'package:case_fe/domain/entity/user.dart';
import 'package:case_fe/feature/users_screen/users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersStateHolder extends StateNotifier<UsersState> {
  UsersStateHolder() : super(const UsersState.initial());

  UsersState get usersState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setUsers(List<User> users) {
    state = state.copyWith(users: users);
  }
}

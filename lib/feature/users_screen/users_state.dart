import 'package:case_fe/domain/entity/user.dart';
import 'package:flutter/material.dart';

@immutable
class UsersState {
  final bool isLoading;
  final List<User> users;

  const UsersState({required this.isLoading, required this.users});

  const UsersState.initial()
      : isLoading = false,
        users = const [];

  UsersState copyWith({bool? isLoading, List<User>? users}) => UsersState(
      isLoading: isLoading ?? this.isLoading, users: users ?? this.users);
}

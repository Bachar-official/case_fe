import 'package:case_fe/domain/entity/permission.dart';
import 'package:flutter/material.dart';

@immutable
class NewUserState {
  final String username;
  final String password;
  final Permission permission;
  final bool isLoading;

  const NewUserState(
      {required this.isLoading,
      required this.password,
      required this.permission,
      required this.username});

  const NewUserState.initial()
      : isLoading = false,
        username = '',
        password = '',
        permission = Permission.update;

  NewUserState copyWith(
          {bool? isLoading,
          String? username,
          String? password,
          Permission? permission}) =>
      NewUserState(
          isLoading: isLoading ?? this.isLoading,
          password: password ?? this.password,
          permission: permission ?? this.permission,
          username: username ?? this.username);
}

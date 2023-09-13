import 'package:flutter/material.dart';

@immutable
class LoginState {
  final String username;
  final String password;
  final bool isLoading;

  const LoginState(
      {required this.password,
      required this.username,
      required this.isLoading});

  const LoginState.initial()
      : username = '',
        password = '',
        isLoading = false;

  LoginState copyWith({String? username, String? password, bool? isLoading}) =>
      LoginState(
          username: username ?? this.username,
          password: password ?? this.password,
          isLoading: isLoading ?? this.isLoading);
}

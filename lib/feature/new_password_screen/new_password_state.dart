import 'package:flutter/material.dart';

@immutable
class NewPasswordState {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;
  final bool isLoading;

  const NewPasswordState(
      {required this.confirmNewPassword,
      required this.isLoading,
      required this.newPassword,
      required this.oldPassword});

  const NewPasswordState.initial()
      : isLoading = false,
        oldPassword = '',
        newPassword = '',
        confirmNewPassword = '';

  NewPasswordState copyWith(
          {String? oldPassword,
          String? newPassword,
          String? confirmNewPassword,
          bool? isLoading}) =>
      NewPasswordState(
          confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
          isLoading: isLoading ?? this.isLoading,
          newPassword: newPassword ?? this.newPassword,
          oldPassword: oldPassword ?? this.oldPassword);
}

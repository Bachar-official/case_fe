import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/feature/new_password_screen/new_password_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NewPasswordManager {
  final NetRepo netRepo;
  final TokenRepo tokenRepo;
  final NewPasswordStateHolder holder;
  final Logger logger;
  final GlobalKey<ScaffoldMessengerState> key;

  NewPasswordManager(
      {required this.holder,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo,
      required this.key});

  bool get isAuthenticated => tokenRepo.token.isNotEmpty;

  final TextEditingController oldController = TextEditingController(text: '');
  final TextEditingController newController = TextEditingController(text: '');
  final TextEditingController confirmController =
      TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();

  String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    return null;
  }

  String? validateNewPassword(String? newPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    if (newPassword != holder.newPasswordState.confirmNewPassword) {
      return 'Пароли должны совпадать';
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    if (confirmPassword != holder.newPasswordState.newPassword) {
      return 'Пароли должны совпадать';
    }
    return null;
  }

  void setOldPassword(String oldPassword) => holder.setOldPassword(oldPassword);
  void setNewPassword(String newPassword) => holder.setNewPassword(newPassword);
  void setConfirmPassword(String confirmPassword) =>
      holder.setConfirmPassword(confirmPassword);

  void clearOldPassword() {
    holder.setOldPassword('');
    oldController.value = TextEditingValue.empty;
  }

  void clearNewPassword() {
    holder.setNewPassword('');
    newController.value = TextEditingValue.empty;
  }

  void clearConfirmPassword() {
    holder.setConfirmPassword('');
    confirmController.value = TextEditingValue.empty;
  }

  void setLoading(bool isLoading) => holder.setLoading(isLoading);

  Future<bool> changePassword() async {
    logger.d('Try to change password');
    setLoading(true);
    try {
      var response = await netRepo.updatePassword(
          tokenRepo.token,
          holder.newPasswordState.newPassword,
          holder.newPasswordState.oldPassword);
      if (response) {
        logger.i('Password changed');
        showSnackBar(
            key, Colors.green, 'Пароль изменён. Пожалуйста, войдите снова.');
        return true;
      } else {
        logger.w('Problems with changing password');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
        return false;
      }
    } on DioException catch (e, s) {
      logger.e(e.message, stackTrace: s);
      showSnackBar(key, Colors.red, e.response?.data);
      return false;
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }
}

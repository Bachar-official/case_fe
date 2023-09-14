import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/new_user_screen/new_user_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NewUserManager {
  final NetRepo netRepo;
  final Logger logger;
  final NewUserStateHolder holder;
  final GlobalKey<ScaffoldMessengerState> key;
  final TokenRepo tokenRepo;

  NewUserManager(
      {required this.holder,
      required this.key,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get canCreate => tokenRepo.permission?.canManageUsers ?? false;

  void setLoading(bool isLoading) => holder.setLoading(isLoading);
  void setUsername(String username) => holder.setUsername(username);
  void setPassword(String password) => holder.setPassword(password);
  void setPermission(Permission? permission) {
    if (permission != null) {
      holder.setPermission(permission);
    }
  }

  String? validateNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    return null;
  }

  void clearUsername() {
    setUsername('');
    usernameController.value = TextEditingValue.empty;
  }

  void clearPassword() {
    setPassword('');
    passwordController.value = TextEditingValue.empty;
  }

  Future<bool> createUser() async {
    logger.d('Try to create new user');
    setLoading(true);

    try {
      var response = await netRepo.createUser(
          tokenRepo.token,
          holder.newUserState.username,
          holder.newUserState.password,
          holder.newUserState.permission);
      if (!response) {
        logger.w('Something wrong with creating user');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
        setLoading(false);
        return false;
      } else {
        logger.i('New user created');
        clearUsername();
        clearPassword();
        setLoading(false);
        return true;
      }
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.response?.data);
      setLoading(false);
      return true;
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      setLoading(false);
      return true;
    }
  }
}

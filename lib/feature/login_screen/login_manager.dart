import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/feature/login_screen/login_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginManager {
  final LoginStateHolder holder;
  final Logger logger;
  final NetRepo netRepo;
  final TokenRepo tokenRepo;
  final GlobalKey<ScaffoldMessengerState> key;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginManager(
      {required this.holder,
      required this.key,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo});

  void setUsername(String username) => holder.setUsername(username);
  void setPassword(String password) => holder.setPassword(password);
  void setLoading(bool isLoading) => holder.setLoading(isLoading);

  void clearUsername() {
    holder.clearUserName();
    usernameController.value = const TextEditingValue(text: '');
  }

  void clearPassword() {
    holder.clearPassword();
    passwordController.value = const TextEditingValue(text: '');
  }

  Future<bool> auth() async {
    logger.d('Try to auth');
    setLoading(true);
    try {
      var response = await netRepo.auth(
          holder.loginState.username, holder.loginState.password);
      if (response == null) {
        logger.w('Something wrong with auth');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так!');
        return false;
      } else {
        await tokenRepo.setToken(response);
        clearUsername();
        clearPassword();
        setLoading(false);
        logger.i('Token got successfully');
        return true;
      }
    } on DioException catch (e) {
      logger.e(e.message);
      showSnackBar(key, Colors.red, e.response?.data ?? '');
      clearUsername();
      clearPassword();
      setLoading(false);
      return false;
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      clearUsername();
      clearPassword();
      setLoading(false);
      return false;
    }
  }
}

import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/user.dart';
import 'package:case_fe/feature/users_screen/users_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UsersManager {
  final NetRepo netRepo;
  final TokenRepo tokenRepo;
  final UsersStateHolder holder;
  final Logger logger;
  final GlobalKey<ScaffoldMessengerState> key;

  UsersManager(
      {required this.holder,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo,
      required this.key});

  bool get isAuthorized => tokenRepo.token.isNotEmpty;
  String get username => tokenRepo.username;

  void setLoading(bool isLoading) => holder.setLoading(isLoading);
  void setUsers(List<User> users) => holder.setUsers(users);

  Future<void> getUsers() async {
    logger.d('Try to get users');
    try {
      var result = await netRepo.getUsers(tokenRepo.token);
      if (result == null) {
        logger.w('Something wrong with getting users');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
        setLoading(false);
      } else {
        setUsers(result);
        logger.i('Got ${result.length} users!');
        setLoading(false);
      }
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      setLoading(false);
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      setLoading(false);
    }
  }

  Future<void> deleteUser(User user) async {
    logger.d('Trying to delete user');
    setLoading(true);
    try {
      var result = await netRepo.deleteUser(tokenRepo.token, user.name);
      if (result) {
        setLoading(false);
        await getUsers();
      } else {
        logger.w('Problems with deleting user');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
      }
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.response?.data);
      setLoading(false);
    } on Exception catch (e, s) {
      logger.e(e.toString(), stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      setLoading(false);
    }
  }
}

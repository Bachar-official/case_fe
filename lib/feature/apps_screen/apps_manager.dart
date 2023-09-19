import 'package:case_fe/const/theme.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/settings_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../domain/entity/app.dart';

class AppsManager {
  final AppsStateHolder holder;
  final Logger logger;
  final NetRepo netRepo;
  final TokenRepo tokenRepo;
  final SettingsRepo settingsRepo;
  final GlobalKey<ScaffoldMessengerState> key;

  String get baseUrl => netRepo.config.apiUrl;

  AppsManager(
      {required this.holder,
      required this.logger,
      required this.netRepo,
      required this.settingsRepo,
      required this.tokenRepo,
      required this.key}) {
    holder.setTheme(settingsRepo.theme);
  }

  bool get isAuthorized => tokenRepo.token != '';
  bool get canUpdate => tokenRepo.permission?.canUpdate ?? false;
  bool get canUpload => tokenRepo.permission?.canUpload ?? false;
  String get username => tokenRepo.username;
  String get shortUsername => tokenRepo.shortUsername;

  void setTheme() async {
    logger.d('Try to change and save theme');
    if (holder.appsState.theme == ColorTheme.dark) {
      holder.setTheme(ColorTheme.light);
      await settingsRepo.setTheme(ColorTheme.light);
    } else {
      holder.setTheme(ColorTheme.dark);
      await settingsRepo.setTheme(ColorTheme.dark);
    }
    logger.i('Theme changed successfully');
  }

  void setLoading(bool isLoading) => holder.setLoading(isLoading);

  void clearToken() async {
    logger.d('Try to clear token');
    setLoading(true);
    await tokenRepo.clearToken();
    setLoading(false);
    logger.i('Token cleared');
  }

  Future<void> onGetApps() async {
    logger.d('Request all apps');
    setLoading(true);
    try {
      var response = await netRepo.getApps();
      if (response == null) {
        logger.w('Something wrong with apps');
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
      } else {
        holder.setApps(response);
        logger.i('Got ${response.length} apps');
      }
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
    } finally {
      setLoading(false);
    }
  }

  void onDeleteApp(App app) async {
    logger.d('Try to delete app ${app.name}');
    setLoading(true);
    try {
      bool result = await netRepo.deleteApp(app.package, tokenRepo.token);
      if (result) {
        logger.i('App ${app.name} deleted');
        await onGetApps();
      } else {
        logger.w('Something wrong with deleting app ${app.name}');
        setLoading(false);
        showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
      }
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.response?.data);
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
    } finally {
      setLoading(false);
    }
  }
}

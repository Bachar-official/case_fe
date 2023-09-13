import 'package:case_fe/const/theme.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/settings_repo.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AppsManager {
  final AppsStateHolder holder;
  final Logger logger;
  final NetRepo netRepo;
  final SettingsRepo settingsRepo;
  final GlobalKey<ScaffoldMessengerState> key;

  AppsManager(
      {required this.holder,
      required this.logger,
      required this.netRepo,
      required this.settingsRepo,
      required this.key});

  void setTheme() {
    logger.d('Try to change and save theme');
    if (holder.appsState.theme == ColorTheme.dark) {
      holder.setTheme(ColorTheme.light);
      settingsRepo.setTheme(ColorTheme.light);
    } else {
      holder.setTheme(ColorTheme.dark);
      settingsRepo.setTheme(ColorTheme.dark);
    }
    logger.i('Theme changed successfully');
  }

  Future<void> onGetApps() async {
    logger.d('Request all apps');
    holder.setLoading(true);
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
      holder.setLoading(false);
    }
  }
}

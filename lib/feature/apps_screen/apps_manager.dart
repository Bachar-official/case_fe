import 'package:case_fe/const/theme.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AppsManager {
  final AppsStateHolder holder;
  final Logger logger;
  final NetRepo netRepo;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  AppsManager(
      {required this.holder,
      required this.logger,
      required this.netRepo,
      required this.scaffoldKey});

  void setTheme(ColorTheme theme) => holder.setTheme(theme);

  Future<void> onGetApps() async {
    logger.d('Request all apps');
    holder.setLoading(true);
    try {
      var response = await netRepo.getApps();
      if (response == null) {
        showSnackBar(scaffoldKey, Colors.yellow, 'Что-то пошло не так');
      } else {
        holder.setApps(response);
      }
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
    } finally {
      holder.setLoading(false);
    }
  }
}

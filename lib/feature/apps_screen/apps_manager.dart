import 'package:case_fe/const/theme.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
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

  void setTheme() {
    if (holder.appsState.theme == ColorTheme.dark) {
      holder.setTheme(ColorTheme.light);
    } else {
      holder.setTheme(ColorTheme.dark);
    }
  }

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
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(scaffoldKey, Colors.red, e.toString());
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(scaffoldKey, Colors.red, e.toString());
    } finally {
      holder.setLoading(false);
    }
  }
}

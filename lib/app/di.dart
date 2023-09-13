import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/settings_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/feature/home_screen/home_manager.dart';
import 'package:case_fe/feature/home_screen/home_state_holder.dart';
import 'package:case_fe/feature/login_screen/login_manager.dart';
import 'package:case_fe/feature/login_screen/login_state_holder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DI {
  // Configs and repos
  late final AppConfig config;
  late final NetRepo netRepo;
  final TokenRepo tokenRepo = TokenRepo();
  final SettingsRepo settingsRepo = SettingsRepo();

  // Managers
  late final HomeManager homeManager;
  late final AppsManager appsManager;
  late final LoginManager loginManager;

  final Logger logger = Logger();
  final Dio dio = Dio();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // State holders
  final HomeStateHolder homeHolder = HomeStateHolder();
  final AppsStateHolder appsHolder = AppsStateHolder();
  final LoginStateHolder loginHolder = LoginStateHolder();

  DI();

  Future<void> init() async {
    config = await AppConfig.fromEnv();
    netRepo = NetRepo(dio: dio, config: config);

    homeManager = HomeManager(holder: homeHolder);
    appsManager = AppsManager(
        tokenRepo: tokenRepo,
        holder: appsHolder,
        logger: logger,
        netRepo: netRepo,
        key: scaffoldKey,
        settingsRepo: settingsRepo);
    loginManager = LoginManager(
        holder: loginHolder,
        key: scaffoldKey,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo);

    await appsManager.onGetApps();
  }
}

final di = DI();

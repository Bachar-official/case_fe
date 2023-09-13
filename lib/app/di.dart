import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/apps_screen/apps_state_holder.dart';
import 'package:case_fe/feature/home_screen/home_screen_manager.dart';
import 'package:case_fe/feature/home_screen/home_screen_state_holder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DI {
  late final AppConfig config;
  late final NetRepo netRepo;

  // Managers
  late final HomeScreenManager homeManager;
  late final AppsManager appsManager;

  final Logger logger = Logger();
  final Dio dio = Dio();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // State holders
  final HomeScreenStateHolder homeHolder = HomeScreenStateHolder();
  final AppsStateHolder appsHolder = AppsStateHolder();

  DI();

  Future<void> init() async {
    config = await AppConfig.fromEnv();
    netRepo = NetRepo(dio: dio, config: config);

    homeManager = HomeScreenManager(holder: homeHolder);
    appsManager = AppsManager(
        holder: appsHolder,
        logger: logger,
        netRepo: netRepo,
        scaffoldKey: scaffoldKey);
  }
}

final di = DI();

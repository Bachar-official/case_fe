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
import 'package:case_fe/feature/new_apk_screen/new_apk_manager.dart';
import 'package:case_fe/feature/new_apk_screen/new_apk_state_holder.dart';
import 'package:case_fe/feature/new_app_screen/new_app_manager.dart';
import 'package:case_fe/feature/new_app_screen/new_app_state_holder.dart';
import 'package:case_fe/feature/new_password_screen/new_password_manager.dart';
import 'package:case_fe/feature/new_password_screen/new_password_state_holder.dart';
import 'package:case_fe/feature/new_user_screen/new_user_manager.dart';
import 'package:case_fe/feature/new_user_screen/new_user_state_holder.dart';
import 'package:case_fe/feature/profile_screen/profile_manager.dart';
import 'package:case_fe/feature/users_screen/users_manager.dart';
import 'package:case_fe/feature/users_screen/users_state_holder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class DI {
  // Configs and repos
  late final AppConfig config;
  late final NetRepo netRepo;
  late final TokenRepo tokenRepo;
  late final SettingsRepo settingsRepo;

  // Managers
  late final HomeManager homeManager;
  late final AppsManager appsManager;
  late final LoginManager loginManager;
  late final NewPasswordManager newPasswordManager;
  late final ProfileManager profileManager;
  late final UsersManager usersManager;
  late final NewUserManager newUserManager;
  late final NewAppManager newAppManager;
  late final NewApkManager newApkManager;

  final Logger logger = Logger();
  final Dio dio = Dio();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  // State holders
  final HomeStateHolder homeHolder = HomeStateHolder();
  final AppsStateHolder appsHolder = AppsStateHolder();
  final LoginStateHolder loginHolder = LoginStateHolder();
  final NewPasswordStateHolder newPasswordStateHolder =
      NewPasswordStateHolder();
  final UsersStateHolder usersHolder = UsersStateHolder();
  final NewUserStateHolder newUserHolder = NewUserStateHolder();
  final NewAppStateHolder newAppHolder = NewAppStateHolder();
  final NewApkStateHolder newApkHolder = NewApkStateHolder();

  DI();

  Future<void> init() async {
    config = await AppConfig.fromEnv();
    netRepo = NetRepo(dio: dio, config: config);
    Box settingsBox = await Hive.openBox('settings');
    Box tokenBox = await Hive.openBox('token');
    settingsRepo = SettingsRepo(settingsBox: settingsBox);
    tokenRepo = TokenRepo(tokenBox: tokenBox);

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
    newPasswordManager = NewPasswordManager(
        key: scaffoldKey,
        holder: newPasswordStateHolder,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo);
    usersManager = UsersManager(
        holder: usersHolder,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo,
        key: scaffoldKey);

    profileManager = ProfileManager(
        tokenRepo: tokenRepo,
        appsManager: appsManager,
        usersManager: usersManager);

    newUserManager = NewUserManager(
        holder: newUserHolder,
        key: scaffoldKey,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo);
    newAppManager = NewAppManager(
        holder: newAppHolder,
        appsManager: appsManager,
        key: scaffoldKey,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo);
    newApkManager = NewApkManager(
        appsManager: appsManager,
        holder: newApkHolder,
        key: scaffoldKey,
        logger: logger,
        netRepo: netRepo,
        tokenRepo: tokenRepo);

    await appsManager.onGetApps();
  }
}

final di = DI();

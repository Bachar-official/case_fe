import 'dart:io';

import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/new_app_screen/new_app_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class NewAppManager {
  final NewAppStateHolder holder;
  final AppsManager appsManager;
  final TokenRepo tokenRepo;
  final NetRepo netRepo;
  final GlobalKey<ScaffoldMessengerState> key;
  final Logger logger;

  NewAppManager(
      {required this.holder,
      required this.appsManager,
      required this.key,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController packageC = TextEditingController();
  final TextEditingController versionC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();

  bool get canCreate => tokenRepo.permission?.canUpdate ?? false;

  void setLoading(bool isLoading) => holder.setLoading(isLoading);
  void setName(String name) => holder.setName(name);
  void setPackage(String package) => holder.setPackage(package);
  void setVersion(String version) => holder.setVersion(version);
  void setDescription(String description) => holder.setDescription(description);

  void setIcon(XFile? file) async {
    logger.d('Setting icon');
    if (kIsWeb) {
      if (file == null) {
        holder.setWebIcon(null);
        logger.i('Web icon cleared');
      } else {
        holder.setWebIcon(await file.readAsBytes());
        logger.d('Web icon set');
      }
    } else if (Platform.isAndroid) {
      if (file == null) {
        holder.setIcon(null);
        logger.i('Icon cleared');
      } else {
        holder.setIcon(File(file.path));
        logger.d('Icon set');
      }
    }
  }

  void clearName() {
    setName('');
    nameC.value = TextEditingValue.empty;
  }

  void clearPackage() {
    setPackage('');
    packageC.value = TextEditingValue.empty;
  }

  void clearVersion() {
    setVersion('');
    versionC.value = TextEditingValue.empty;
  }

  void clearDescription() {
    setDescription('');
    descriptionC.value = TextEditingValue.empty;
  }

  void clearIcon() {
    setIcon(null);
  }

  Future<bool> createApp() async {
    logger.d('Try to create new app');
    setLoading(true);
    try {
      var response = await netRepo.createApp(
          holder.appState.package,
          holder.appState.name,
          holder.appState.version,
          kIsWeb
              ? holder.appState.webIcon == null
                  ? null
                  : File.fromRawPath(holder.appState.webIcon!)
              : holder.appState.icon,
          holder.appState.description,
          tokenRepo.token);
      if (response) {
        logger.i('App created');
        clearName();
        clearPackage();
        clearDescription();
        clearIcon();
        clearVersion();
        setLoading(false);
        await appsManager.onGetApps();
        return response;
      }
      logger.w('Something wrong with creating app');
      showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
      return response;
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.response?.data);
      setLoading(false);
      return false;
    } on Exception catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red, e.toString());
      setLoading(false);
      return false;
    }
  }
}

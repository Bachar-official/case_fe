import 'dart:io';

import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class EditAppManager {
  final EditAppStateHolder holder;
  final NetRepo netRepo;
  final TokenRepo tokenRepo;
  final Logger logger;
  final GlobalKey<ScaffoldMessengerState> key;
  final AppsManager appsManager;

  EditAppManager(
      {required this.appsManager,
      required this.logger,
      required this.holder,
      required this.key,
      required this.netRepo,
      required this.tokenRepo});

  bool get canUpdate => tokenRepo.permission?.canUpdate ?? false;

  late final TextEditingController nameC =
      TextEditingController(text: holder.editState.name);
  late final TextEditingController versionC =
      TextEditingController(text: holder.editState.version);
  late final TextEditingController descriptionC =
      TextEditingController(text: holder.editState.description);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setLoading(bool isLoading) => holder.setLoading(isLoading);

  void setIcon(XFile? file) async {
    logger.d('Try to set icon');
    if (file == null) {
      holder.setIcon(null);
      holder.setWebIcon(null);
      logger.i('Icon cleared');
    } else {
      if (kIsWeb) {
        var bytes = await file.readAsBytes();
        holder.setWebIcon(bytes);
      } else {
        holder.setIcon(File(file.path));
      }
      logger.i('Icon set');
    }
  }

  void collectData() {
    holder.setName(nameC.text);
    holder.setVersion(versionC.text);
    holder.setDescription(descriptionC.text);
  }

  void clearIcon() => setIcon(null);

  Future<bool> updateApp(String package) async {
    collectData();
    logger.d('Try to update app ${holder.editState.name}');
    setLoading(true);
    try {
      var response = await netRepo.updateApp(
          package: package,
          token: tokenRepo.token,
          name: holder.editState.name,
          version: holder.editState.version,
          description: holder.editState.description,
          icon: holder.editState.icon,
          webIcon: holder.editState.webIcon);
      if (response) {
        logger.i('App updated');
        setLoading(false);
        await appsManager.onGetApps();
        return response;
      }
      logger.w('Something wrong with editing app');
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

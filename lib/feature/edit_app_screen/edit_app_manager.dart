import 'dart:io';

import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/edit_app_screen/edit_app_state_holder.dart';
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

  final TextEditingController nameC = TextEditingController();
  final TextEditingController versionC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();

  void setName(String name) => holder.setName(name);
  void setVersion(String version) => holder.setVersion(version);
  void setDescription(String description) => holder.setDescription(description);

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

  void clearName() {
    setName('');
    nameC.value = TextEditingValue.empty;
  }

  void clearVersion() {
    setVersion('');
    versionC.value = TextEditingValue.empty;
  }

  void clearDescription() {
    setDescription('');
    descriptionC.value = TextEditingValue.empty;
  }

  void clearIcon() => setIcon(null);
}

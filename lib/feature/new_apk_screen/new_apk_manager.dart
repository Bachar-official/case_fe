import 'package:case_fe/data/repository/net_repo.dart';
import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/arch.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';
import 'package:case_fe/feature/new_apk_screen/new_apk_state_holder.dart';
import 'package:case_fe/utils/show_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NewApkManager {
  final TokenRepo tokenRepo;
  final NetRepo netRepo;
  final NewApkStateHolder holder;
  final Logger logger;
  final GlobalKey<ScaffoldMessengerState> key;
  final AppsManager appsManager;

  NewApkManager(
      {required this.holder,
      required this.key,
      required this.logger,
      required this.netRepo,
      required this.tokenRepo,
      required this.appsManager});

  bool get canUpload => tokenRepo.permission?.canUpload ?? false;
  int get fileSize => _getFileSize();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _getFileSize() {
    if (holder.apkState.apk == null) {
      return 0;
    }
    var sizeInBytes =
        4 * ((holder.apkState.apk!.length / 3)).ceil() * 0.5624896334383812;
    return (sizeInBytes / 1024).round();
  }

  void setLoading(bool isLoading) => holder.setLoading(isLoading);
  void setPackage(String package) => holder.setPackage(package);
  void setArch(Arch? arch) {
    if (arch == null) {
      holder.setArch(Arch.common);
    } else {
      holder.setArch(arch);
    }
  }

  void setFile() async {
    logger.d('Try to pick a file');
    setLoading(true);
    try {
      FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['apk'],
      );
      if (pickerResult != null) {
        await compute(setApk, pickerResult.files.single.bytes);
      }
      setLoading(false);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      showSnackBar(key, Colors.red,
          'Ошибка при попытке прикрепить файл: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<void> setApk(Uint8List? bytes) async {
    if (bytes == null) {
      holder.setApk(null);
    } else {
      holder.setApk(bytes);
    }
  }

  Future<bool> uploadApk(String? packageName) async {
    logger.d('Try to upload an apk');
    setLoading(true);
    try {
      bool response = await netRepo.uploadApp(
          packageName ?? holder.apkState.package,
          tokenRepo.token,
          holder.apkState.apk!,
          holder.apkState.arch.name);
      if (response) {
        logger.i('APK uploaded');
        setApk(null);
        await appsManager.onGetApps();
        setLoading(false);
        return response;
      }
      logger.w('Something wrong with uploading an apk');
      showSnackBar(key, Colors.yellow, 'Что-то пошло не так');
      setLoading(false);
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

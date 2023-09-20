import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/domain/entity/arch.dart';

class Urls {
  final AppConfig config;

  Urls({required this.config});

  String get appsUrl => '${config.apiUrl}/apps';

  String iconUrl(String iconPath) => '${config.apiUrl}/$iconPath';

  String appPackageUrl(String package) => '$appsUrl/$package';

  String appInfoUrl(String package) => '$appsUrl/$package/info';
  String apkListUrl(String package) => '$appsUrl/$package/apk';
  String apkUploadUrl(String package) => '$appsUrl/$package/upload';

  String downloadApkUrl({required App app, Arch? arch}) =>
      '${appPackageUrl(app.package)}/${getStringFromArch(arch)}/download';

  String downloadIconUrl({required String package}) =>
      '${appPackageUrl(package)}/icon';

  String uploadApkUrl({required String package}) =>
      '${appPackageUrl(package)}/upload';

  String get authUrl => '${config.apiUrl}/auth';
  String get usersUrl => '$authUrl/users';
  String get createUserUrl => '$authUrl/add';
  String get deleteUserUrl => '$authUrl/delete';
  String get updatePasswordUrl => '$authUrl/password';
}

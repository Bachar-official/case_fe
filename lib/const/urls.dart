import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/domain/entity/arch.dart';

class Urls {
  final AppConfig config;

  Urls({required this.config});

  String get appsUrl => '${config.apiUrl}/apps';

  String appPackageUrl(String package) => '${config.apiUrl}/$package';

  String appInfoUrl(String package) => '${appPackageUrl(package)}/info';

  String downloadApkUrl({required String package, Arch? arch}) =>
      '${appPackageUrl(package)}/${getStringFromArch(arch)}/download';

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

import 'package:case_fe/app/app_config.dart';

class Urls {
  final AppConfig config;

  Urls({required this.config});

  String get appsUrl => '${config.apiUrl}/apps';
}

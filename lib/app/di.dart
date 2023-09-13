import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/data/repository/net_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DI {
  late final AppConfig config;
  late final NetRepo netRepo;

  final Logger logger = Logger();
  final Dio dio = Dio();

  DI();

  Future<void> init() async {
    config = await AppConfig.fromEnv();
    netRepo = NetRepo(dio: dio, config: config);
  }
}

final di = DI();

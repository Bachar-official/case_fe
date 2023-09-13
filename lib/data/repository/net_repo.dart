import 'dart:convert';

import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/const/urls.dart';
import 'package:case_fe/utils/parse_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/app.dart';

class NetRepo {
  final Dio dio;
  final AppConfig config;
  late final Urls urls;

  NetRepo({required this.dio, required this.config}) {
    urls = Urls(config: config);
  }

  Future<List<App>?> getApps() async {
    var response = await dio.get(urls.appsUrl);
    if (response.statusCode == 200) {
      var array = jsonDecode(response.data) as List<dynamic>;
      return compute(parseApps, array);
    } else {
      return null;
    }
  }
}

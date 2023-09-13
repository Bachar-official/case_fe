import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String apiUrl;

  AppConfig({required this.apiUrl});

  static Future<AppConfig> fromEnv() async {
    final content = await rootBundle.loadString('assets/config/env.json');
    final json = jsonDecode(content);
    return AppConfig(apiUrl: json['apiUrl']);
  }
}

import 'package:case_fe/domain/entity/apk.dart';
import 'package:case_fe/domain/entity/user.dart';

import '../domain/entity/app.dart';

List<App> parseApps(List<dynamic> response) =>
    response.map((element) => App.fromJson(element)).toList();

List<User> parseUsers(List<dynamic> response) =>
    response.map((element) => User.fromJson(element)).toList();

List<APK> parseApks(List<dynamic> response) =>
    response.map((element) => APK.fromJson(element)).toList();

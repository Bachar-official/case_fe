import 'dart:convert';

import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/const/urls.dart';
import 'package:case_fe/domain/entity/apk.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/domain/entity/user.dart';
import 'package:case_fe/utils/parse_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/app.dart';

const contentTypeHeader = {'Content-Type': 'application/json'};

const getMethod = 'GET';
const postMethod = 'POST';
const patchMethod = 'PATCH';
const deleteMethod = 'DELETE';

class NetRepo {
  final Dio dio;
  final AppConfig config;
  late final Urls urls;

  NetRepo({required this.dio, required this.config}) {
    urls = Urls(config: config);
  }

  Future<List<App>?> getApps() async {
    var response = await dio.get(urls.appsUrl,
        options: Options(method: getMethod, headers: contentTypeHeader));
    if (response.statusCode == 200) {
      if (response.data is List) {
        return compute(parseApps, response.data as List<dynamic>);
      }
      var array = jsonDecode(response.data) as List;
      return compute(parseApps, array);
    } else {
      return null;
    }
  }

  Future<List<APK>?> getAppApk(String package) async {
    var response = await dio.get(urls.apkListUrl(package),
        options: Options(method: getMethod));
    if (response.statusCode == 200) {
      if (response.data is List) {
        return compute(parseApks, response.data as List<dynamic>);
      }
      var array = jsonDecode(response.data) as List;
      return compute(parseApks, array);
    } else {
      return null;
    }
  }

  Future<bool> createApp(String package, String name, String version,
      String? icon, String description, String token) async {
    var response = await dio.post(urls.appInfoUrl(package),
        options: Options(method: postMethod, headers: contentTypeHeader),
        data: {
          'token': token,
          'name': name,
          'version': version,
          'description': description.isEmpty ? null : description,
          'icon': icon
        });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteApp(String package, String token) async {
    var response = await dio.delete(urls.appPackageUrl(package),
        options: Options(method: deleteMethod, headers: contentTypeHeader),
        data: {"token": token});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<User>?> getUsers(String token) async {
    var response = await dio.post(urls.usersUrl,
        options: Options(method: postMethod, headers: contentTypeHeader),
        data: {"token": token});
    if (response.statusCode == 200) {
      if (response.data is List) {
        return compute(parseUsers, response.data as List<dynamic>);
      }
      var array = jsonDecode(response.data) as List;
      return compute(parseUsers, array);
    } else {
      return null;
    }
  }

  Future<String?> auth(String username, String password) async {
    var response = await dio.post(urls.authUrl,
        options: Options(method: postMethod, headers: contentTypeHeader),
        data: {"username": username, "password": password});
    if (response.statusCode == 200) {
      return json.decode(response.data)['token'];
    } else {
      return null;
    }
  }

  Future<bool> updatePassword(
      String token, String password, String oldPassword) async {
    var response = await dio.patch(urls.updatePasswordUrl,
        options: Options(
          method: patchMethod,
          headers: contentTypeHeader,
        ),
        data: {
          'token': token,
          'password': password,
          'oldPassword': oldPassword
        });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> createUser(String token, String username, String password,
      Permission permission) async {
    var response = await dio.post(
      urls.createUserUrl,
      options: Options(
        method: postMethod,
        headers: contentTypeHeader,
      ),
      data: {
        'token': token,
        'username': username,
        'password': password,
        'permission': permission.name
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteUser(String token, String username) async {
    var response = await dio.delete(urls.deleteUserUrl,
        options: Options(method: deleteMethod, headers: contentTypeHeader),
        data: {'token': token, 'username': username});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

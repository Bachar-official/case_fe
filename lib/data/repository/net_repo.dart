import 'dart:convert';
import 'dart:io';

import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/const/urls.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/domain/entity/user.dart';
import 'package:case_fe/utils/modify_map.dart';
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

  Future<bool> createApp(
      {required String package,
      required String name,
      required String version,
      File? icon,
      Uint8List? webIcon,
      required String description,
      required String token}) async {
    Map<String, dynamic> data = removeNullMapValues({
      'token': token,
      'name': name,
      'version': version,
      'description': description.isEmpty ? null : description,
      'icon': icon == null && webIcon == null
          ? null
          : kIsWeb
              ? MultipartFile.fromBytes(webIcon!, filename: 'icon.png')
              : MultipartFile.fromFileSync(icon!.path, filename: 'icon.png')
    });
    var response = await dio.post(urls.appInfoUrl(package),
        options: Options(method: postMethod, headers: contentTypeHeader),
        data: FormData.fromMap(data));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateApp(
      {required String package,
      required String token,
      required String name,
      required String version,
      required String description,
      File? icon,
      Uint8List? webIcon}) async {
    Map<String, dynamic> data = removeNullMapValues({
      'token': token,
      'name': name,
      'version': version,
      'description': description,
      'icon': icon == null && webIcon == null
          ? null
          : kIsWeb
              ? MultipartFile.fromBytes(webIcon!, filename: 'icon.png')
              : MultipartFile.fromFileSync(icon!.path, filename: 'icon.png')
    });
    var response = await dio.patch(urls.appInfoUrl(package),
        options: Options(method: patchMethod, headers: contentTypeHeader),
        data: FormData.fromMap(data));
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

  Future<bool> uploadApp(
      String package, String token, Uint8List body, String arch) async {
    Map<String, dynamic> data = removeNullMapValues({
      'token': token,
      'apk': MultipartFile.fromBytes(body, filename: 'app.apk'),
      'arch': arch
    });
    var response = await dio.post(urls.uploadApkUrl(package: package),
        options: Options(method: postMethod, headers: contentTypeHeader),
        data: FormData.fromMap(data));
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

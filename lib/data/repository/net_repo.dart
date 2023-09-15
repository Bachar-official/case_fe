import 'dart:convert';

import 'package:case_fe/app/app_config.dart';
import 'package:case_fe/const/urls.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/domain/entity/user.dart';
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
    var response = await dio.get(urls.appsUrl,
        options: Options(method: 'GET', headers: {
          'Content-Type': 'application/json',
        }));
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

  Future<List<User>?> getUsers(String token) async {
    var response = await dio.post(urls.usersUrl,
        options: Options(method: 'POST', headers: {
          'Content-Type': 'application/json',
        }),
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
        options: Options(method: 'POST', headers: {
          'Content-Type': 'application/json',
        }),
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
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
          },
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
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
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
        options: Options(method: 'DELETE', headers: {
          'Content-Type': 'application/json',
        }),
        data: {'token': token, 'username': username});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

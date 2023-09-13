import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/utils/parse_token.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokenRepo {
  static const _token = 'token';
  final Box tokenBox;

  TokenRepo({required this.tokenBox});

  String get token => tokenBox.get(_token, defaultValue: '');
  Permission? get permission => getPermission(token);
  String get shortUsername => getUsernameFirstLetter(token) ?? '?';
  String get username => getUsername(token) ?? '?';

  Future<void> setToken(String token) async {
    await tokenBox.put(_token, token);
  }

  Future<void> clearToken() async {
    await tokenBox.put(_token, '');
  }
}

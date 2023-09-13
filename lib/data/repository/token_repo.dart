import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/utils/parse_token.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokenRepo {
  static const _token = 'token';
  final Box _tokenBox = Hive.box(_token);

  TokenRepo();

  String get token => _tokenBox.get(_token, defaultValue: '');
  Permission? get permission => getPermission(token);

  void setToken(String token) async {
    await _tokenBox.put(_token, token);
  }

  void clearToken() async {
    await _tokenBox.put(_token, '');
  }
}

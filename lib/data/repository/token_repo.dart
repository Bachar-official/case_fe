import 'package:hive_flutter/hive_flutter.dart';

class TokenRepo {
  static const _token = 'token';
  final Box _tokenBox = Hive.box(_token);

  TokenRepo();

  String get token => _tokenBox.get(_token, defaultValue: '');

  void setToken(String token) async {
    await _tokenBox.put(_token, token);
  }

  void clearToken() async {
    await _tokenBox.put(_token, '');
  }
}

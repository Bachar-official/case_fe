import 'dart:convert';

import 'package:case_fe/domain/entity/permission.dart';

String? _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      return null;
  }

  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic>? _parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return null;
  }
  final payload = _decodeBase64(parts[1]);
  if (payload == null) {
    return null;
  }
  final payloadMap = json.decode(payload);
  return payloadMap;
}

Permission? getPermission(String token) {
  Map<String, dynamic>? jwt = _parseJwt(token);
  if (jwt == null) {
    return null;
  }
  return getPermissionFromString(jwt['permission']);
}

String? getUsernameFirstLetter(String token) {
  Map<String, dynamic>? jwt = _parseJwt(token);
  if (jwt == null) {
    return null;
  }
  return jwt['username'].split('')[0];
}

String? getUsername(String token) {
  Map<String, dynamic>? jwt = _parseJwt(token);
  if (jwt == null) {
    return null;
  }
  return jwt['username'];
}

import 'package:case_fe/domain/entity/permission.dart';

class User {
  final String name;
  final Permission permission;

  const User({required this.name, required this.permission});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        permission = getPermissionFromString(json['permission']);
}

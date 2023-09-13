import '../domain/entity/app.dart';

List<App> parseApps(List<dynamic> response) =>
    response.map((element) => App.fromJson(element)).toList();

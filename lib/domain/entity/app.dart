import 'package:case_fe/domain/entity/apk.dart';
import 'package:case_fe/utils/compare_versions.dart';

class App {
  final String name;
  final String package;
  final String? iconPath;
  final String? description;
  final String version;
  final List<APK> apk;

  App(
      {required this.name,
      required this.version,
      required this.package,
      this.iconPath,
      this.description = 'Описания пока нет',
      required this.apk});

  App.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        package = json['package'],
        iconPath = json['iconPath'],
        version = json['version'],
        description = json['description'],
        apk = List<dynamic>.from(json['apk'])
            .map((e) => APK.fromJson(e))
            .toList();

  App copyWith({List<APK>? apk}) => App(
      name: name,
      package: package,
      iconPath: iconPath,
      description: description,
      version: version,
      apk: apk ?? this.apk);

  @override
  String toString() =>
      'App with name $name, package $package, version $version, iconPath $iconPath, apkLength: ${apk.length}';

  @override
  int get hashCode => version.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! App) {
      return false;
    }
    return compareVersions(version1: version, version2: other.version) == 0;
  }

  bool operator <(Object other) {
    if (other is! App) {
      return false;
    }
    return compareVersions(version1: version, version2: other.version) == -1;
  }

  bool operator >(Object other) {
    if (other is! App) {
      return false;
    }
    return compareVersions(version1: version, version2: other.version) == 1;
  }

  bool operator <=(Object other) => this == other || this < other;
  bool operator >=(Object other) => this == other || this > other;
}

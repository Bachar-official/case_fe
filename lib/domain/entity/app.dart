class App {
  final String name;
  final String package;
  final String? iconPath;
  final String? description;
  final String version;

  App(
      {required this.name,
      required this.version,
      required this.package,
      this.iconPath,
      this.description = 'Описания пока нет'});

  App.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        package = json['package'],
        iconPath = json['iconPath'],
        version = json['version'],
        description = json['description'];

  @override
  String toString() =>
      'App with name $name, package $package, version $version, iconPath $iconPath';
}

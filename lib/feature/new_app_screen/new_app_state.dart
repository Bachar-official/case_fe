import 'package:flutter/material.dart';

@immutable
class NewAppState {
  final String name;
  final String package;
  final String version;
  final String? icon;
  final String description;
  final bool isLoading;

  const NewAppState(
      {required this.name,
      required this.package,
      required this.version,
      required this.isLoading,
      required this.description,
      this.icon});

  const NewAppState.initial()
      : name = '',
        package = '',
        version = '',
        isLoading = false,
        description = '',
        icon = null;

  NewAppState copyWith({
    String? name,
    String? package,
    String? version,
    String? icon,
    bool? isLoading,
    String? description,
    bool nullIcon = false,
  }) =>
      NewAppState(
          name: name ?? this.name,
          package: package ?? this.package,
          version: version ?? this.version,
          isLoading: isLoading ?? this.isLoading,
          icon: nullIcon ? null : icon ?? this.icon,
          description: description ?? this.description);
}

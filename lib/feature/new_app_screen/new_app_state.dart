import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

@immutable
class NewAppState {
  final String name;
  final String package;
  final String version;
  final File? icon;
  final Uint8List? webIcon;
  final String description;
  final bool isLoading;

  const NewAppState(
      {required this.name,
      required this.package,
      required this.version,
      required this.isLoading,
      required this.description,
      this.webIcon,
      this.icon});

  const NewAppState.initial()
      : name = '',
        package = '',
        version = '',
        isLoading = false,
        description = '',
        icon = null,
        webIcon = null;

  NewAppState copyWith({
    String? name,
    String? package,
    String? version,
    File? icon,
    Uint8List? webIcon,
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
          webIcon: nullIcon ? null : webIcon ?? this.webIcon,
          description: description ?? this.description);
}

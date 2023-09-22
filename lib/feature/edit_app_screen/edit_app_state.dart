import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

@immutable
class EditAppState {
  final bool isLoading;
  final String name;
  final String version;
  final File? icon;
  final Uint8List? webIcon;
  final String description;

  const EditAppState(
      {required this.isLoading,
      required this.name,
      required this.version,
      required this.description,
      this.icon,
      this.webIcon});

  const EditAppState.initial()
      : isLoading = false,
        name = '',
        version = '',
        description = '',
        icon = null,
        webIcon = null;

  EditAppState copyWith(
          {bool? isLoading,
          String? name,
          String? version,
          File? icon,
          Uint8List? webIcon,
          String? description,
          bool nullIcon = false}) =>
      EditAppState(
          isLoading: isLoading ?? this.isLoading,
          name: name ?? this.name,
          version: version ?? this.version,
          description: description ?? this.description,
          icon: nullIcon ? null : icon ?? this.icon,
          webIcon: nullIcon ? null : webIcon ?? this.webIcon);
}

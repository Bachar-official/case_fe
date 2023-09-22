import 'package:case_fe/const/theme.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:flutter/material.dart';

@immutable
class AppsState {
  final ColorTheme theme;
  final List<App> apps;
  final bool isLoading;
  final double downloadProgress;

  const AppsState(
      {required this.apps,
      required this.theme,
      required this.isLoading,
      required this.downloadProgress});

  const AppsState.initial()
      : apps = const [],
        downloadProgress = 0,
        isLoading = false,
        theme = ColorTheme.light;

  AppsState copyWith(
          {ColorTheme? theme,
          List<App>? apps,
          App? selectedApp,
          bool? isLoading,
          double? downloadProgress}) =>
      AppsState(
          apps: apps ?? this.apps,
          downloadProgress: downloadProgress ?? this.downloadProgress,
          theme: theme ?? this.theme,
          isLoading: isLoading ?? this.isLoading);
}

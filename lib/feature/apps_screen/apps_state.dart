import 'package:case_fe/const/theme.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:flutter/material.dart';

@immutable
class AppsState {
  final ColorTheme theme;
  final List<App> apps;
  final bool isLoading;

  const AppsState(
      {required this.apps, required this.theme, required this.isLoading});

  const AppsState.initial()
      : apps = const [],
        isLoading = false,
        theme = ColorTheme.light;

  AppsState copyWith({ColorTheme? theme, List<App>? apps, bool? isLoading}) =>
      AppsState(
          apps: apps ?? this.apps,
          theme: theme ?? this.theme,
          isLoading: isLoading ?? this.isLoading);
}

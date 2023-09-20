import 'package:case_fe/const/theme.dart';
import 'package:case_fe/domain/entity/app.dart';
import 'package:case_fe/feature/apps_screen/apps_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppsStateHolder extends StateNotifier<AppsState> {
  AppsStateHolder() : super(const AppsState.initial());

  AppsState get appsState => state;

  void setTheme(ColorTheme theme) {
    state = state.copyWith(theme: theme);
  }

  void setApps(List<App> apps) {
    state = state.copyWith(apps: apps);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setDownloadProgress(double downloadProgress) {
    state = state.copyWith(downloadProgress: downloadProgress);
  }
}

import 'package:case_fe/const/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepo {
  static const _settings = 'settings';
  static const _theme = 'theme';
  final Box _settingsBox = Hive.box(_settings);

  SettingsRepo();

  ColorTheme get theme =>
      getTheme(_settingsBox.get(_theme, defaultValue: 'light'));

  void setTheme(ColorTheme theme) async {
    await _settingsBox.put(_theme, theme.name);
  }
}

import 'package:case_fe/const/theme.dart';
import 'package:hive/hive.dart';

class SettingsRepo {
  static const _theme = 'theme';
  final Box settingsBox;

  SettingsRepo({required this.settingsBox});

  ColorTheme get theme => _getTheme();

  ColorTheme _getTheme() {
    String themeName = settingsBox.get(_theme, defaultValue: 'light');
    return getTheme(themeName);
  }

  Future<void> setTheme(ColorTheme theme) async {
    await settingsBox.put(_theme, theme.name);
  }
}

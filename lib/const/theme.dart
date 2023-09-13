import 'package:flutter/material.dart';

enum ColorTheme { dark, light }

var darkTheme = ThemeData.dark(useMaterial3: true);
var lightTheme = ThemeData.light(useMaterial3: true);

Map<ColorTheme, ThemeData> themes = {
  ColorTheme.light: lightTheme,
  ColorTheme.dark: darkTheme
};

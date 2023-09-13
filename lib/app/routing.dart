import 'package:case_fe/feature/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appScreen:
        return _buildRoute((context) => const HomeScreen(), settings);
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  static const appScreen = '/';
}

MaterialPageRoute _buildRoute(WidgetBuilder builder, RouteSettings settings) {
  return MaterialPageRoute(settings: settings, builder: builder);
}

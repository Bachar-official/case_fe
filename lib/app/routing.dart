import 'package:case_fe/feature/home_screen/home_screen.dart';
import 'package:case_fe/feature/login_screen/login_screen.dart';
import 'package:case_fe/feature/new_password_screen/new_password_screen.dart';
import 'package:case_fe/feature/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appScreen:
        return _buildRoute((context) => const HomeScreen(), settings);
      case loginScreen:
        return _buildRoute((context) => const LoginScreen(), settings);
      case newPasswordScreen:
        return _buildRoute((context) => const NewPasswordScreen(), settings);
      case profileScreen:
        return _buildRoute((context) => const ProfileScreen(), settings);
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  static const appScreen = '/';
  static const loginScreen = '/login';
  static const newPasswordScreen = '/newPassword';
  static const profileScreen = '/profile';
}

MaterialPageRoute _buildRoute(WidgetBuilder builder, RouteSettings settings) {
  return MaterialPageRoute(settings: settings, builder: builder);
}

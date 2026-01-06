import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/main_screen.dart';

class AppRoutes {
  static const welcome = '/';
  static const main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      default:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    }
  }
}

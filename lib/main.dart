import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const KeamananMotorApp());
}

class KeamananMotorApp extends StatelessWidget {
  const KeamananMotorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keamanan Motor',
      theme: AppTheme.sageTheme,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.welcome,
    );
  }
}

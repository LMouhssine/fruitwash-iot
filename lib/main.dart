import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const FruitWashApp());
}

class FruitWashApp extends StatelessWidget {
  const FruitWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FruitWash',
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}



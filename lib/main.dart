import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // On desktop (Windows/macOS/Linux) and web, Firebase requires explicit options.
  if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)) {
    // For desktop/web in open-source repos, avoid shipping secrets.
    // Use environment variables at runtime or a local, untracked config.
    final String? apiKey = const String.fromEnvironment('FIREBASE_API_KEY');
    final String? appId = const String.fromEnvironment('FIREBASE_APP_ID');
    final String? messagingSenderId = const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    final String? projectId = const String.fromEnvironment('FIREBASE_PROJECT_ID');
    final String? databaseUrl = const String.fromEnvironment('FIREBASE_DATABASE_URL');
    final String? storageBucket = const String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

    if ([apiKey, appId, messagingSenderId, projectId, databaseUrl, storageBucket].any((e) => e == null || e!.isEmpty)) {
      // Initialize a default app without options for desktop tests that only use REST
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey!,
          appId: appId!,
          messagingSenderId: messagingSenderId!,
          projectId: projectId!,
          databaseURL: databaseUrl!,
          storageBucket: storageBucket!,
        ),
      );
    }
  } else {
    await Firebase.initializeApp();
  }

  // Simple test write to Realtime Database
  try {
    await FirebaseDatabase.instance.ref('test').set({
      'timestamp': DateTime.now().toIso8601String(),
      'message': 'Hello from FruitWash',
    });
  } catch (e) {
    // Ignore failures in dev run; could be due to rules
  }

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



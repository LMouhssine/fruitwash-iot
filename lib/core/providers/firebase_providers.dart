import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

final firebaseInitializationProvider = FutureProvider<FirebaseApp>((ref) async {
  try {
    if (kDebugMode) {
      print('Initialisation Firebase...');
      print('Plateforme: ${defaultTargetPlatform.name}');
      print('Is Web: $kIsWeb');
    }

    if (defaultTargetPlatform == TargetPlatform.android || 
        defaultTargetPlatform == TargetPlatform.iOS) {
      // Mobile - utilise google-services.json/GoogleService-Info.plist
      if (kDebugMode) print('Initialisation mobile avec fichiers de configuration');
      return await Firebase.initializeApp();
    } else if (kIsWeb) {
      // Web - nécessite des variables d'environnement
      const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
      const String appId = String.fromEnvironment('FIREBASE_APP_ID');
      const String messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
      const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
      const String databaseUrl = String.fromEnvironment('FIREBASE_DATABASE_URL');
      const String storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

      if ([apiKey, appId, messagingSenderId, projectId, databaseUrl, storageBucket].any((e) => e.isEmpty)) {
        throw Exception(
          'Configuration Firebase manquante pour le web. '
          'Fournissez les valeurs --dart-define lors de la compilation:\n'
          'flutter run -d web --dart-define=FIREBASE_API_KEY=your_key --dart-define=FIREBASE_APP_ID=your_app_id ...'
        );
      }

      if (kDebugMode) print('Initialisation web avec variables d\'environnement');
      
      return await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          databaseURL: databaseUrl,
          storageBucket: storageBucket,
        ),
      );
    } else {
      // Desktop (Windows/macOS/Linux)
      // Essaie d'abord l'initialisation par défaut (utilise google-services.json si présent)
      if (kDebugMode) print('Initialisation desktop par défaut');
      
      try {
        return await Firebase.initializeApp();
      } catch (e) {
        if (kDebugMode) {
          print('Échec de l\'initialisation par défaut: $e');
          print('Tentative avec variables d\'environnement...');
        }
        
        // Fallback avec variables d'environnement pour desktop
        const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
        const String appId = String.fromEnvironment('FIREBASE_APP_ID');
        const String messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
        const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
        const String databaseUrl = String.fromEnvironment('FIREBASE_DATABASE_URL');
        const String storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

        if ([apiKey, appId, messagingSenderId, projectId, databaseUrl, storageBucket].any((e) => e.isEmpty)) {
          throw Exception(
            'Impossible d\'initialiser Firebase pour desktop.\n'
            'Solutions:\n'
            '1. Assurez-vous que google-services.json est présent dans le projet\n'
            '2. Ou fournissez les variables d\'environnement avec --dart-define'
          );
        }
        
        return await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: apiKey,
            appId: appId,
            messagingSenderId: messagingSenderId,
            projectId: projectId,
            databaseURL: databaseUrl,
            storageBucket: storageBucket,
          ),
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur Firebase: $e');
    }
    rethrow;
  }
});
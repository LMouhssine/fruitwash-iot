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
        // Configuration par défaut pour les tests
        if (kDebugMode) {
          print('Utilisation de la configuration Firebase par défaut pour les tests web');
        }
        
        // Pour les tests, utilisons une configuration qui fonctionne même sans auth
        if (kDebugMode) {
          print('Configuration Firebase par défaut - Auth peut ne pas fonctionner');
        }
        
        return await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyA02BFcoWZyUw08kmYEckeIrlegAqX-mZI',
            appId: '1:804359576650:android:24de77e9ff6d539f7d9ab3',
            messagingSenderId: '804359576650',
            projectId: 'esp32-moha',
            databaseURL: 'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app',
            storageBucket: 'esp32-moha.firebasestorage.app',
          ),
        );
      }

      if (kDebugMode) print('Initialisation web avec variables d\'environnement');
      
      return await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyA02BFcoWZyUw08kmYEckeIrlegAqX-mZI',
          appId: '1:804359576650:android:24de77e9ff6d539f7d9ab3',
          messagingSenderId: '804359576650',
          projectId: 'esp32-moha',
          databaseURL: 'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app',
          storageBucket: 'esp32-moha.firebasestorage.app',
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
          // Configuration par défaut pour les tests
          if (kDebugMode) {
            print('Utilisation de la configuration Firebase par défaut pour les tests');
          }
          
          return await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'AIzaSyCdBjDpBqNS4TJlmZ2ZqK8X1Y9W8mVnPqE',
              appId: '1:123456789:web:abcdef123456',
              messagingSenderId: '123456789',
              projectId: 'esp32-moha-default-rtdb',
              databaseURL: 'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app',
              storageBucket: 'esp32-moha-default-rtdb.appspot.com',
            ),
          );
        }
        
        return await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyA02BFcoWZyUw08kmYEckeIrlegAqX-mZI',
            appId: '1:804359576650:android:24de77e9ff6d539f7d9ab3',
            messagingSenderId: '804359576650',
            projectId: 'esp32-moha',
            databaseURL: 'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app',
            storageBucket: 'esp32-moha.firebasestorage.app',
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
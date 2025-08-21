import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Configuration Firebase basée sur google-services.json
class FirebaseConfig {
  static const String apiKey = 'AIzaSyA02BFcoWZyUw08kmYEckeIrlegAqX-mZI';
  static const String appId = '1:804359576650:android:24de77e9ff6d539f7d9ab3';
  static const String messagingSenderId = '804359576650';
  static const String projectId = 'esp32-moha';
  static const String databaseUrl = 'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app';
  static const String storageBucket = 'esp32-moha.firebasestorage.app';
}

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
      // Web - utilise les variables d'environnement si disponibles, sinon config hardcodée
      const String envApiKey = String.fromEnvironment('FIREBASE_API_KEY');
      const String envAppId = String.fromEnvironment('FIREBASE_APP_ID');
      const String envMessagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
      const String envProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
      const String envDatabaseUrl = String.fromEnvironment('FIREBASE_DATABASE_URL');
      const String envStorageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

      final bool hasEnvConfig = [envApiKey, envAppId, envMessagingSenderId, envProjectId, envDatabaseUrl, envStorageBucket]
          .every((e) => e.isNotEmpty);

      if (kDebugMode) print('Initialisation web avec config ${hasEnvConfig ? "d'environnement" : "par défaut"}');
      
      return await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: hasEnvConfig ? envApiKey : FirebaseConfig.apiKey,
          appId: hasEnvConfig ? envAppId : FirebaseConfig.appId,
          messagingSenderId: hasEnvConfig ? envMessagingSenderId : FirebaseConfig.messagingSenderId,
          projectId: hasEnvConfig ? envProjectId : FirebaseConfig.projectId,
          databaseURL: hasEnvConfig ? envDatabaseUrl : FirebaseConfig.databaseUrl,
          storageBucket: hasEnvConfig ? envStorageBucket : FirebaseConfig.storageBucket,
        ),
      );
    } else {
      // Desktop (Windows/macOS/Linux)
      if (kDebugMode) print('Initialisation desktop avec configuration hardcodée');
      
      return await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: FirebaseConfig.apiKey,
          appId: FirebaseConfig.appId,
          messagingSenderId: FirebaseConfig.messagingSenderId,
          projectId: FirebaseConfig.projectId,
          databaseURL: FirebaseConfig.databaseUrl,
          storageBucket: FirebaseConfig.storageBucket,
        ),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur Firebase: $e');
    }
    rethrow;
  }
});
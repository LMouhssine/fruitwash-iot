import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router_new.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/auth_providers.dart';
import 'core/providers/firebase_providers.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'shared/widgets/loading_widget.dart';
import 'shared/widgets/error_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FruitWashApp()));
}

class FruitWashApp extends StatelessWidget {
  const FruitWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FruitWash',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseInit = ref.watch(firebaseInitializationProvider);
    
    return firebaseInit.when(
      data: (_) {
        // Firebase is initialized, now watch auth state
        final authState = ref.watch(authStateProvider);
        
        return authState.when(
          data: (user) {
            if (user != null) {
              return const DashboardScreen();
            } else {
              return const LoginScreen();
            }
          },
          loading: () => const Scaffold(
            body: LoadingWidget(message: 'Chargement...'),
          ),
          error: (error, stack) => Scaffold(
            body: ErrorDisplayWidget(
              message: 'Erreur d\'authentification: $error',
              onRetry: () => ref.invalidate(authStateProvider),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: LoadingWidget(message: 'Initialisation de Firebase...'),
      ),
      error: (error, stack) => Scaffold(
        body: ErrorDisplayWidget(
          message: 'Erreur d\'initialisation Firebase: $error',
          onRetry: () => ref.invalidate(firebaseInitializationProvider),
        ),
      ),
    );
  }
}



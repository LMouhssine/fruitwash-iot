import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_providers.dart';
import 'error_widget.dart';

/// Widget qui écoute les changements d'authentification et affiche les messages appropriés
class AuthListener extends ConsumerWidget {
  final Widget child;
  final bool showSuccessOnLogin;
  final bool showSuccessOnLogout;

  const AuthListener({
    super.key,
    required this.child,
    this.showSuccessOnLogin = false,
    this.showSuccessOnLogout = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      // Gestion des erreurs
      if (current.error != null) {
        ErrorSnackBar.show(context, current.error!);
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    // Écoute des changements d'état d'authentification pour les messages de succès
    ref.listen(authStateProvider, (previous, current) {
      current.whenData((currentUser) {
        if (previous != null) {
          previous.whenData((previousUser) {
            // Connexion réussie
            if (previousUser == null && currentUser != null && showSuccessOnLogin) {
              SuccessSnackBar.show(
                context, 
                'Connexion réussie ! Bienvenue ${currentUser.displayName ?? currentUser.email}',
              );
            }
            // Déconnexion réussie
            else if (previousUser != null && currentUser == null && showSuccessOnLogout) {
              SuccessSnackBar.show(context, 'Déconnexion réussie !');
            }
          });
        }
      });
    });

    return child;
  }
}

/// Wrapper pour les écrans qui nécessitent une authentification
class AuthRequiredWrapper extends ConsumerWidget {
  final Widget child;
  final Widget? unauthorizedWidget;
  final bool showLoading;

  const AuthRequiredWrapper({
    super.key,
    required this.child,
    this.unauthorizedWidget,
    this.showLoading = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return child;
        } else {
          return unauthorizedWidget ?? 
            const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Authentification requise',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vous devez être connecté pour accéder à cette page.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
        }
      },
      loading: () => showLoading 
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : child,
      error: (error, _) => Scaffold(
        body: ErrorDisplayWidget(
          message: 'Erreur d\'authentification: $error',
          onRetry: () => ref.invalidate(authStateProvider),
        ),
      ),
    );
  }
}
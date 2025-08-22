import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('MockAuth: Connexion simulée pour $email');
    }

    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Créer un utilisateur fictif
    final user = UserModel(
      id: 'mock_user_${email.hashCode}',
      email: email,
      displayName: 'Utilisateur Test',
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  @override
  Future<UserModel> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('MockAuth: Création de compte simulée pour $email');
    }

    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Créer un nouvel utilisateur fictif
    final user = UserModel(
      id: 'mock_user_${email.hashCode}',
      email: email,
      displayName: null, // Sera mis à jour après
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  @override
  Future<void> signOut() async {
    if (kDebugMode) {
      print('MockAuth: Déconnexion simulée');
    }

    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> updateDisplayName({required String displayName}) async {
    if (kDebugMode) {
      print('MockAuth: Mise à jour du nom: $displayName');
    }

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(displayName: displayName);
      _authStateController.add(_currentUser);
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (kDebugMode) {
      print('MockAuth: Changement de mot de passe simulé');
    }

    // Simulation d'un délai
    await Future.delayed(const Duration(milliseconds: 500));

    // En mode mock, on accepte toujours le changement
    // En vrai, on vérifierait le mot de passe actuel
  }

  void dispose() {
    _authStateController.close();
  }
}
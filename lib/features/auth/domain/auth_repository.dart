import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });
  
  Future<UserModel> createUserWithEmailPassword({
    required String email,
    required String password,
  });
  
  Future<void> signOut();
  
  Future<void> updateDisplayName({required String displayName});
  
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth}) 
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  @override
  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Échec de la connexion');
      }
      
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<UserModel> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Échec de la création du compte');
      }
      
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName({required String displayName}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }
    
    await user.updateDisplayName(displayName);
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      // Réauthentification nécessaire pour changer le mot de passe
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  Exception _mapFirebaseException(FirebaseAuthException e) {
    // Debug: afficher l'erreur complète en mode debug
    if (kDebugMode) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
    }
    
    switch (e.code) {
      case 'user-not-found':
        return Exception('Aucun utilisateur trouvé avec cette adresse e-mail.');
      case 'wrong-password':
        return Exception('Mot de passe incorrect.');
      case 'invalid-email':
        return Exception('Adresse e-mail invalide.');
      case 'user-disabled':
        return Exception('Ce compte a été désactivé.');
      case 'too-many-requests':
        return Exception('Trop de tentatives. Réessayez plus tard.');
      case 'operation-not-allowed':
        return Exception('L\'authentification par email/mot de passe n\'est pas activée dans Firebase.');
      case 'weak-password':
        return Exception('Le mot de passe est trop faible.');
      case 'email-already-in-use':
        return Exception('Cette adresse e-mail est déjà utilisée.');
      case 'invalid-credential':
        return Exception('Identifiants invalides.');
      case 'invalid-api-key':
        return Exception('Clé API Firebase invalide.');
      case 'app-not-authorized':
        return Exception('Application non autorisée à utiliser Firebase.');
      default:
        return Exception('Erreur Firebase (${e.code}): ${e.message}');
    }
  }
}
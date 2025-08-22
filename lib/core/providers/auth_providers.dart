import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/models/user_model.dart';
import 'firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Utiliser Firebase Auth
  ref.watch(firebaseInitializationProvider);
  if (kDebugMode) {
    print('AuthProvider: Utilisation de Firebase Auth');
  }
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  // Attendre Firebase initialization
  final firebaseApp = ref.watch(firebaseInitializationProvider);
  
  return firebaseApp.when(
    data: (_) {
      final repository = ref.watch(authRepositoryProvider);
      return repository.authStateChanges;
    },
    loading: () => const Stream.empty(),
    error: (error, _) => Stream.error(error),
  );
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.currentUser;
});

class AuthState {
  final bool isLoading;
  final String? error;
  
  const AuthState({
    this.isLoading = false,
    this.error,
  });
  
  AuthState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  
  AuthNotifier(this._authRepository) : super(const AuthState());
  
  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  Future<bool> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authRepository.createUserWithEmailPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authRepository.signOut();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
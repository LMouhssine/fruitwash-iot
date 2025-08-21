class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final DateTime? lastSignIn;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.lastSignIn,
    required this.createdAt,
  });

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      lastSignIn: firebaseUser.metadata?.lastSignInTime,
      createdAt: firebaseUser.metadata?.creationTime ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
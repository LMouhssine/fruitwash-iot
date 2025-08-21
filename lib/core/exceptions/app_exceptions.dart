abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => message;
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

class FirebaseException extends AppException {
  const FirebaseException(super.message, {super.code});
}

class DeviceException extends AppException {
  const DeviceException(super.message, {super.code});
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Une erreur inconnue s\'est produite']);
}
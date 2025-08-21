import '../constants/app_constants.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre adresse e-mail';
    }
    
    if (value.length > AppConstants.maxEmailLength) {
      return 'L\'adresse e-mail est trop longue';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Adresse e-mail invalide';
    }
    
    return null;
  }
  
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Le mot de passe doit contenir au moins ${AppConstants.minPasswordLength} caractères';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Le mot de passe est trop long';
    }
    
    return null;
  }
  
  static String? confirmPassword(String? value, String? originalPassword) {
    final passwordError = password(value);
    if (passwordError != null) return passwordError;
    
    if (value != originalPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }
  
  static String? displayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre nom';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < AppConstants.minDisplayNameLength) {
      return 'Le nom doit contenir au moins ${AppConstants.minDisplayNameLength} caractères';
    }
    
    if (trimmedValue.length > AppConstants.maxDisplayNameLength) {
      return 'Le nom est trop long';
    }
    
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(trimmedValue)) {
      return 'Le nom ne peut contenir que des lettres et des espaces';
    }
    
    return null;
  }
  
  static String? required(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }
  
  static String? minLength(String? value, int minLength, {String fieldName = 'Ce champ'}) {
    if (value == null || value.length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }
    return null;
  }
  
  static String? maxLength(String? value, int maxLength, {String fieldName = 'Ce champ'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName ne peut pas dépasser $maxLength caractères';
    }
    return null;
  }
}
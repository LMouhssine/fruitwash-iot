class AppConstants {
  static const String appName = 'FruitWash';
  static const String appVersion = '0.1.0';
  
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  static const int maxEmailLength = 255;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minDisplayNameLength = 2;
  static const int maxDisplayNameLength = 50;
  
  static const String firebaseDatabaseUrl = 
      'https://esp32-moha-default-rtdb.europe-west1.firebasedatabase.app';
  
  static const List<String> supportedImageExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
}

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String devices = '/devices';
  static const String device = '/device';
  static const String machines = '/machines';
  static const String wash = '/wash';
  static const String settings = '/settings';
  static const String history = '/history';
  static const String alerts = '/alerts';
  static const String pairing = '/pair';
  static const String schedule = '/schedule';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String test = '/test';
}

class AppAssets {
  static const String imagesPath = 'assets/images/';
  static const String translationsPath = 'assets/translations/';
  
  static const String logoPath = '${imagesPath}logo.png';
}
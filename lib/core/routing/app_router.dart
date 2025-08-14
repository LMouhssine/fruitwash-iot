import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/devices/presentation/devices_screen.dart';
import '../../features/devices/presentation/device_detail_screen.dart';
import '../../features/wash/presentation/wash_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/alerts/presentation/alerts_screen.dart';
import '../../features/pairing/presentation/pair_device_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/devices': (context) => const DevicesScreen(),
        '/wash': (context) => const WashScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/register': (context) => const RegisterScreen(),
        '/history': (context) => const HistoryScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/pair': (context) => const PairDeviceScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/profile': (context) => const ProfileScreen(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/device') {
      final args = settings.arguments as Map<String, dynamic>?;
      final deviceId = args?['deviceId'] as String?;
      return MaterialPageRoute(
        builder: (_) => DeviceDetailScreen(deviceId: deviceId ?? ''),
      );
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route non trouvée')),
      ),
    );
  }
}



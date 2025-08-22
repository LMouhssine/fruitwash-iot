import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
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
import '../../features/machines/presentation/machines_screen.dart';
import '../../features/machines/presentation/machine_test_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';

class AppRouter {
  static const String initialRoute = AppRoutes.login;

  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.test: (context) => const MachineTestScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.devices: (context) => const DevicesScreen(),
        AppRoutes.machines: (context) => const MachinesScreen(),
        AppRoutes.wash: (context) => const WashScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.history: (context) => const HistoryScreen(),
        AppRoutes.alerts: (context) => const AlertsScreen(),
        AppRoutes.pairing: (context) => const PairDeviceScreen(),
        AppRoutes.schedule: (context) => const ScheduleScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.editProfile: (context) => const EditProfileScreen(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.device) {
      final args = settings.arguments as Map<String, dynamic>?;
      final deviceId = args?['deviceId'] as String?;
      return MaterialPageRoute(
        builder: (_) => DeviceDetailScreen(deviceId: deviceId ?? ''),
        settings: settings,
      );
    }
    
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route non trouvée'),
        ),
      ),
      settings: settings,
    );
  }

  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
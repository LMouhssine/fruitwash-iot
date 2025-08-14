import 'package:flutter/material.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/widgets/section_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _severityColor(BuildContext context, String sev) {
    final scheme = Theme.of(context).colorScheme;
    switch (sev) {
      case 'warning':
        return scheme.tertiary;
      case 'error':
        return Colors.red;
      default:
        return scheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Notifications',
            child: Column(
              children: [
                for (final a in MockData.alerts)
                  ListTile(
                    leading: Icon(Icons.notification_important, color: _severityColor(context, a['severity'] as String)),
                    title: Text(a['title'] as String),
                    subtitle: Text('Appareil: ${a['deviceId']}'),
                    trailing: Text((a['severity'] as String).toUpperCase()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



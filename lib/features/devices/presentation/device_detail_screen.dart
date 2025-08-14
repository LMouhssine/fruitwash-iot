import 'package:flutter/material.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails – $deviceId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statut: connecté', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Dernière activité: maintenant'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new),
              label: const Text('Redémarrer'),
            ),
          ],
        ),
      ),
    );
  }
}



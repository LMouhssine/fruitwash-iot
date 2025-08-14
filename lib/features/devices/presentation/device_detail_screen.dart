import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails – $deviceId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Informations',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statut: connecté', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('Dernière activité: maintenant'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Actions',
            child: Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Redémarrer'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Logs'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



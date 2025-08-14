import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const devices = [
      {'id': 'dev-001', 'name': 'Lave-Fruits #1'},
      {'id': 'dev-002', 'name': 'Lave-Fruits #2'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Appareils')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Liste',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device['name'] as String),
                  subtitle: Text(device['id'] as String),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                    child: Icon(Icons.memory, color: Theme.of(context).colorScheme.secondary),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/device',
                      arguments: {'deviceId': device['id']},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



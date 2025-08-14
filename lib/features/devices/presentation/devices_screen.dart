import 'package:flutter/material.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = const [
      {'id': 'dev-001', 'name': 'Lave-Fruits #1'},
      {'id': 'dev-002', 'name': 'Lave-Fruits #2'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Appareils')),
      body: ListView.separated(
        itemCount: devices.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device['name'] as String),
            subtitle: Text(device['id'] as String),
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
    );
  }
}



import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionCard(
            title: 'Général',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Langue'),
                  subtitle: Text('Français'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text('Serveur / Broker'),
                  subtitle: Text('mqtt://broker.local'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



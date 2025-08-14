import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Langue'),
            subtitle: Text('Français'),
          ),
          ListTile(
            leading: Icon(Icons.wifi),
            title: Text('Serveur / Broker'),
            subtitle: Text('mqtt://broker.local'),
          ),
        ],
      ),
    );
  }
}



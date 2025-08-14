import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionCard(
            title: 'Informations',
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Utilisateur démo'),
              subtitle: Text('demo@example.com'),
            ),
          ),
          SizedBox(height: 12),
          SectionCard(
            title: 'Sécurité',
            child: ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Changer le mot de passe'),
              subtitle: Text('Non connecté à un backend'),
            ),
          ),
        ],
      ),
    );
  }
}



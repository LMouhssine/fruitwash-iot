import 'package:flutter/material.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/logout_widget.dart';

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
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  subtitle: Text('Activées'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SectionCard(
            title: 'Apparence',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.palette),
                  title: Text('Thème'),
                  subtitle: Text('Clair'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Taille du texte'),
                  subtitle: Text('Normale'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SectionCard(
            title: 'Sécurité',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Authentification biométrique'),
                  subtitle: Text('Désactivée'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock_clock),
                  title: Text('Verrouillage automatique'),
                  subtitle: Text('Après 5 minutes'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SectionCard(
            title: 'Compte',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Modifier le profil'),
                  subtitle: Text('Nom, email, mot de passe'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.backup),
                  title: Text('Sauvegarder les données'),
                  subtitle: Text('Synchronisation cloud'),
                ),
                Divider(height: 1),
                LogoutTile(
                  title: 'Se déconnecter',
                  subtitle: 'Quitter votre session',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/logout_widget.dart';
import '../../../core/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: const [
          LogoutButton(
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Informations personnelles',
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      currentUser?.displayName?.isNotEmpty == true 
                        ? currentUser!.displayName![0].toUpperCase()
                        : currentUser?.email.isNotEmpty == true
                          ? currentUser!.email[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(currentUser?.displayName ?? 'Utilisateur'),
                  subtitle: Text(currentUser?.email ?? 'Non connecté'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.of(context).pushNamed('/edit-profile');
                  },
                ),
                if (currentUser?.createdAt != null) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Membre depuis'),
                    subtitle: Text(
                      '${currentUser!.createdAt.day}/${currentUser.createdAt.month}/${currentUser.createdAt.year}',
                    ),
                  ),
                ],
                if (currentUser?.lastSignIn != null) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Dernière connexion'),
                    subtitle: Text(
                      '${currentUser!.lastSignIn!.day}/${currentUser.lastSignIn!.month}/${currentUser.lastSignIn!.year}',
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: 'Sécurité',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Changer le mot de passe'),
                  subtitle: Text('Modifier votre mot de passe'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Authentification à deux facteurs'),
                  subtitle: Text('Sécuriser votre compte'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: 'Préférences',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  subtitle: Text('Gérer vos notifications'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Confidentialité'),
                  subtitle: Text('Contrôler vos données'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: 'Actions',
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Exporter mes données'),
                  subtitle: Text('Télécharger vos informations'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.orange),
                  title: Text('Supprimer le compte', style: TextStyle(color: Colors.orange)),
                  subtitle: Text('Action irréversible'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                LogoutTile(
                  title: 'Se déconnecter',
                  subtitle: 'Fermer votre session',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



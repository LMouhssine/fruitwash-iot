import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Navigation',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _NavTile(icon: Icons.devices_other, label: 'Appareils', route: '/devices', color: colors.primary),
                _NavTile(icon: Icons.local_laundry_service, label: 'Lavage', route: '/wash', color: colors.secondary),
                _NavTile(icon: Icons.settings, label: 'Paramètres', route: '/settings', color: colors.tertiary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionCard(
            title: 'Statistiques rapides',
            child: Row(
              children: [
                Expanded(child: _StatTile(label: 'Appareils', value: '2')),
                SizedBox(width: 12),
                Expanded(child: _StatTile(label: 'Cycles', value: '0')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionCard(
            title: 'Accès rapide',
            child: Wrap(
              spacing: 8,
              children: [
                _QuickButton(label: 'Historique', icon: Icons.history, route: '/history'),
                _QuickButton(label: 'Alertes', icon: Icons.notifications_active, route: '/alerts'),
                _QuickButton(label: 'Appairer', icon: Icons.link, route: '/pair'),
                _QuickButton(label: 'Planifier', icon: Icons.schedule, route: '/schedule'),
                _QuickButton(label: 'Profil', icon: Icons.person, route: '/profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.label, required this.route, this.color});
  final IconData icon;
  final String label;
  final String route;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({required this.label, required this.icon, required this.route});
  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}



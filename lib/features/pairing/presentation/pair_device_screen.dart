import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';

class PairDeviceScreen extends StatelessWidget {
  const PairDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Appairer un appareil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Saisie du code',
            child: Column(
              children: [
                TextField(
                  controller: code,
                  decoration: const InputDecoration(
                    labelText: 'Code d\'appairage',
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(label: 'Appairer', icon: Icons.link, onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Scan réseau',
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.wifi_find),
                  label: const Text('Scanner'),
                ),
                const SizedBox(width: 8),
                const Text('Aucun appareil détecté'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



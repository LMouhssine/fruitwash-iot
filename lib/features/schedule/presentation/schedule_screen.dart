import 'package:flutter/material.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/primary_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay time = const TimeOfDay(hour: 8, minute: 0);
  bool repeatDaily = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Heure',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time.format(context)),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: time);
                    if (picked != null) setState(() => time = picked);
                  },
                  icon: const Icon(Icons.access_time),
                  label: const Text('Modifier'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Récurrence',
            child: SwitchListTile(
              title: const Text('Répéter tous les jours'),
              value: repeatDaily,
              onChanged: (v) => setState(() => repeatDaily = v),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: 'Enregistrer', icon: Icons.save_outlined, onPressed: () {}),
        ],
      ),
    );
  }
}



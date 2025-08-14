import 'package:flutter/material.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/widgets/section_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Cycles passés',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.history.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final h = MockData.history[idx];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('Appareil: ${h['deviceId']}'),
                  subtitle: Text('${h['date']} • ${h['duration']} min • eau ${h['water']}%'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



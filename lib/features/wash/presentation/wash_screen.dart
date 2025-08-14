import 'package:flutter/material.dart';

class WashScreen extends StatefulWidget {
  const WashScreen({super.key});

  @override
  State<WashScreen> createState() => _WashScreenState();
}

class _WashScreenState extends State<WashScreen> {
  double durationMinutes = 5;
  double waterLevel = 50;
  bool running = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle de lavage')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Durée (min)'),
                Text(durationMinutes.toStringAsFixed(0)),
              ],
            ),
            Slider(
              min: 1,
              max: 30,
              divisions: 29,
              value: durationMinutes,
              onChanged: running
                  ? null
                  : (v) => setState(() => durationMinutes = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Niveau d\'eau (%)'),
                Text(waterLevel.toStringAsFixed(0)),
              ],
            ),
            Slider(
              min: 10,
              max: 100,
              divisions: 9,
              value: waterLevel,
              onChanged: running
                  ? null
                  : (v) => setState(() => waterLevel = v),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() => running = !running),
              icon: Icon(running ? Icons.stop : Icons.play_arrow),
              label: Text(running ? 'Arrêter' : 'Démarrer'),
            ),
          ],
        ),
      ),
    );
  }
}



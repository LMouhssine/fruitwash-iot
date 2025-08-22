import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/machine_providers.dart';

class MachineTestScreen extends ConsumerWidget {
  const MachineTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Firebase Machines'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions de test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      onPressed: () => _testUpdateMachine(ref, 'machine-001', 'HAUT'),
                      label: 'Machine-001 → HAUT',
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      onPressed: () => _testUpdateMachine(ref, 'machine-001', 'BAS'),
                      label: 'Machine-001 → BAS',
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      onPressed: () => _testAddEvent(ref, 'machine-001', 'HAUT'),
                      label: 'Ajouter événement HAUT',
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      onPressed: () => _testAddEvent(ref, 'machine-001', 'BAS'),
                      label: 'Ajouter événement BAS',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/machines');
              },
              child: const Text('Voir les machines'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testUpdateMachine(WidgetRef ref, String machineId, String niveau) async {
    try {
      final updateFunction = ref.read(machineUpdateProvider(machineId));
      await updateFunction(niveau);
      
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Machine $machineId mise à jour: $niveau'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testAddEvent(WidgetRef ref, String machineId, String niveau) async {
    try {
      final addEventFunction = ref.read(machineEventAddProvider(machineId));
      await addEventFunction(niveau);
      
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Événement ajouté pour $machineId: $niveau'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
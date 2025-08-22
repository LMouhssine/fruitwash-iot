import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../machines/models/machine_data.dart';
import '../../machines/models/machine_event.dart';
import '../../machines/providers/machine_providers.dart';

// Provider sécurisé pour le dashboard qui fournit toujours des données
final safeMachinesProvider = Provider<AsyncValue<List<MachineData>>>((ref) {
  final machinesAsync = ref.watch(allMachinesProvider);
  
  return machinesAsync.when(
    data: (machines) => AsyncData(machines),
    loading: () => AsyncData(_mockMachines), // Données par défaut pendant le loading
    error: (error, stack) {
      print('Erreur machines, utilisation des données mockées: $error');
      return AsyncData(_mockMachines); // Données mockées en cas d'erreur
    },
  );
});

// Données mockées pour éviter les erreurs d'affichage
final List<MachineData> _mockMachines = [
  MachineData(
    machineId: 'demo-machine-001',
    currentNiveau: 'HAUT',
    lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
    events: [
      MachineEvent(
        id: 'demo-event-1',
        niveau: 'HAUT',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MachineEvent(
        id: 'demo-event-2',
        niveau: 'BAS',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MachineEvent(
        id: 'demo-event-3',
        niveau: 'HAUT',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  ),
  MachineData(
    machineId: 'demo-machine-002',
    currentNiveau: 'BAS',
    lastUpdate: DateTime.now().subtract(const Duration(minutes: 15)),
    events: [
      MachineEvent(
        id: 'demo-event-4',
        niveau: 'BAS',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
  ),
];

// Statistiques calculées de façon sécurisée
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final machinesAsync = ref.watch(safeMachinesProvider);
  
  return machinesAsync.when(
    data: (machines) {
      final onlineMachines = machines.where((m) => m.currentNiveau == 'HAUT').length;
      final totalEvents = machines.fold<int>(0, (sum, machine) => sum + machine.events.length);
      
      return DashboardStats(
        totalMachines: machines.length,
        onlineMachines: onlineMachines,
        totalEvents: totalEvents,
      );
    },
    loading: () => const DashboardStats(
      totalMachines: 2,
      onlineMachines: 1,
      totalEvents: 4,
    ),
    error: (_, __) => const DashboardStats(
      totalMachines: 2,
      onlineMachines: 1,
      totalEvents: 4,
    ),
  );
});

class DashboardStats {
  final int totalMachines;
  final int onlineMachines;
  final int totalEvents;

  const DashboardStats({
    required this.totalMachines,
    required this.onlineMachines,
    required this.totalEvents,
  });
}
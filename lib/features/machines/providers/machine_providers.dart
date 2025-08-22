import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/firebase_database_service.dart';
import '../domain/machine_repository.dart';
import '../models/machine_data.dart';
import '../models/machine_event.dart';

final firebaseDatabaseServiceProvider = Provider<FirebaseDatabaseService>((ref) {
  return FirebaseDatabaseService();
});

final machineRepositoryProvider = Provider<MachineRepository>((ref) {
  final databaseService = ref.watch(firebaseDatabaseServiceProvider);
  return MachineRepository(databaseService);
});

final allMachinesProvider = StreamProvider<List<MachineData>>((ref) {
  final repository = ref.watch(machineRepositoryProvider);
  return repository.watchAllMachines().handleError((error) {
    print('Erreur dans allMachinesProvider: $error');
    return <MachineData>[];
  });
});

final machineProvider = StreamProvider.family<MachineData?, String>((ref, machineId) {
  final repository = ref.watch(machineRepositoryProvider);
  return repository.watchMachine(machineId);
});

final machineEventsProvider = StreamProvider.family<List<MachineEvent>, String>((ref, machineId) {
  final repository = ref.watch(machineRepositoryProvider);
  return repository.watchMachineEvents(machineId, limit: 50);
});

final machineUpdateProvider = Provider.family<Future<void> Function(String), String>((ref, machineId) {
  final repository = ref.watch(machineRepositoryProvider);
  return (niveau) => repository.updateMachineLevel(machineId, niveau);
});

final machineEventAddProvider = Provider.family<Future<void> Function(String), String>((ref, machineId) {
  final repository = ref.watch(machineRepositoryProvider);
  return (niveau) => repository.addMachineEvent(machineId, niveau);
});
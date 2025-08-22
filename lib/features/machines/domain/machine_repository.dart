import '../../../core/services/firebase_database_service.dart';
import '../models/machine_data.dart';
import '../models/machine_event.dart';

class MachineRepository {
  final FirebaseDatabaseService _databaseService;

  MachineRepository(this._databaseService);

  Stream<MachineData?> watchMachine(String machineId) {
    return _databaseService.watchMachine(machineId);
  }

  Stream<List<MachineData>> watchAllMachines() {
    return _databaseService.watchAllMachines();
  }

  Future<MachineData?> getMachine(String machineId) {
    return _databaseService.getMachine(machineId);
  }

  Future<List<MachineData>> getAllMachines() {
    return _databaseService.getAllMachines();
  }

  Future<void> updateMachineLevel(String machineId, String niveau) {
    return _databaseService.updateMachineLevel(machineId, niveau);
  }

  Future<void> addMachineEvent(String machineId, String niveau) {
    return _databaseService.addMachineEvent(machineId, niveau);
  }

  Stream<List<MachineEvent>> watchMachineEvents(String machineId, {int? limit}) {
    return _databaseService.watchMachineEvents(machineId, limit: limit);
  }

  Future<List<MachineEvent>> getMachineEvents(String machineId, {int? limit}) {
    return _databaseService.getMachineEvents(machineId, limit: limit);
  }
}
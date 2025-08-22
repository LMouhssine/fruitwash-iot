import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../features/machines/models/machine_data.dart';
import '../../features/machines/models/machine_event.dart';

class FirebaseDatabaseService {
  static const String _machinesPath = 'machines';
  
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Stream<MachineData?> watchMachine(String machineId) {
    return _databaseRef
        .child('$_machinesPath/$machineId')
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        return null;
      }
      
      try {
        final data = event.snapshot.value;
        if (data is! Map) return null;
        return MachineData.fromJson(machineId, Map<String, dynamic>.from(data));
      } catch (e) {
        if (kDebugMode) {
          print('Erreur parsing machine data: $e');
        }
        return null;
      }
    });
  }

  Stream<List<MachineData>> watchAllMachines() {
    return _databaseRef.child(_machinesPath).onValue.map((event) {
      if (event.snapshot.value == null) {
        return <MachineData>[];
      }

      try {
        final data = event.snapshot.value;
        if (data is! Map) return <MachineData>[];
        
        final machinesMap = Map<String, dynamic>.from(data);
        return machinesMap.entries
            .map((entry) {
              try {
                final value = entry.value;
                if (value is! Map) return null;
                return MachineData.fromJson(entry.key, Map<String, dynamic>.from(value));
              } catch (e) {
                if (kDebugMode) {
                  print('Erreur parsing machine ${entry.key}: $e');
                }
                return null;
              }
            })
            .where((machine) => machine != null)
            .cast<MachineData>()
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Erreur parsing machines list: $e');
        }
        return <MachineData>[];
      }
    });
  }

  Future<MachineData?> getMachine(String machineId) async {
    try {
      final snapshot = await _databaseRef.child('$_machinesPath/$machineId').get();
      
      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      final data = snapshot.value;
      if (data is! Map) return null;
      return MachineData.fromJson(machineId, Map<String, dynamic>.from(data));
    } catch (e) {
      if (kDebugMode) {
        print('Erreur récupération machine $machineId: $e');
      }
      return null;
    }
  }

  Future<List<MachineData>> getAllMachines() async {
    try {
      final snapshot = await _databaseRef.child(_machinesPath).get();
      
      if (!snapshot.exists || snapshot.value == null) {
        return <MachineData>[];
      }

      final data = snapshot.value;
      if (data is! Map) return <MachineData>[];
      
      final machinesMap = Map<String, dynamic>.from(data);
      return machinesMap.entries
          .map((entry) {
            try {
              final value = entry.value;
              if (value is! Map) return null;
              return MachineData.fromJson(entry.key, Map<String, dynamic>.from(value));
            } catch (e) {
              if (kDebugMode) {
                print('Erreur parsing machine ${entry.key}: $e');
              }
              return null;
            }
          })
          .where((machine) => machine != null)
          .cast<MachineData>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur récupération machines: $e');
      }
      return <MachineData>[];
    }
  }

  Future<void> updateMachineLevel(String machineId, String niveau) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      
      await _databaseRef.child('$_machinesPath/$machineId').update({
        'niveau': niveau,
        'ts': timestamp,
      });

      final eventRef = _databaseRef.child('$_machinesPath/$machineId/events').push();
      await eventRef.set({
        'niveau': niveau,
        'ts': timestamp,
      });

      if (kDebugMode) {
        print('Machine $machineId mise à jour: $niveau');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur mise à jour machine $machineId: $e');
      }
      rethrow;
    }
  }

  Future<void> addMachineEvent(String machineId, String niveau) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      
      final eventRef = _databaseRef.child('$_machinesPath/$machineId/events').push();
      await eventRef.set({
        'niveau': niveau,
        'ts': timestamp,
      });

      if (kDebugMode) {
        print('Événement ajouté pour machine $machineId: $niveau');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur ajout événement machine $machineId: $e');
      }
      rethrow;
    }
  }

  Stream<List<MachineEvent>> watchMachineEvents(String machineId, {int? limit}) {
    Query query = _databaseRef.child('$_machinesPath/$machineId/events');
    
    if (limit != null) {
      query = query.orderByChild('ts').limitToLast(limit);
    }
    
    return query.onValue.map((event) {
      if (event.snapshot.value == null) {
        return <MachineEvent>[];
      }

      try {
        final data = event.snapshot.value;
        if (data is! Map) return <MachineEvent>[];
        
        final eventsMap = Map<String, dynamic>.from(data);
        final events = eventsMap.entries
            .map((entry) {
              try {
                final value = entry.value;
                if (value is! Map) return null;
                return MachineEvent.fromJson(entry.key, Map<String, dynamic>.from(value));
              } catch (e) {
                if (kDebugMode) {
                  print('Erreur parsing event ${entry.key}: $e');
                }
                return null;
              }
            })
            .where((event) => event != null)
            .cast<MachineEvent>()
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return events;
      } catch (e) {
        if (kDebugMode) {
          print('Erreur parsing events: $e');
        }
        return <MachineEvent>[];
      }
    });
  }

  Future<List<MachineEvent>> getMachineEvents(String machineId, {int? limit}) async {
    try {
      Query query = _databaseRef.child('$_machinesPath/$machineId/events');
      
      if (limit != null) {
        query = query.orderByChild('ts').limitToLast(limit);
      }
      
      final snapshot = await query.get();
      
      if (!snapshot.exists || snapshot.value == null) {
        return <MachineEvent>[];
      }

      final data = snapshot.value;
      if (data is! Map) return <MachineEvent>[];
      
      final eventsMap = Map<String, dynamic>.from(data);
      final events = eventsMap.entries
          .map((entry) {
            try {
              final value = entry.value;
              if (value is! Map) return null;
              return MachineEvent.fromJson(entry.key, Map<String, dynamic>.from(value));
            } catch (e) {
              if (kDebugMode) {
                print('Erreur parsing event ${entry.key}: $e');
              }
              return null;
            }
          })
          .where((event) => event != null)
          .cast<MachineEvent>()
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return events;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur récupération events machine $machineId: $e');
      }
      return <MachineEvent>[];
    }
  }
}
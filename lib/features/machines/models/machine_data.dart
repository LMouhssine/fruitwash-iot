import 'machine_event.dart';

class MachineData {
  final String machineId;
  final String currentNiveau;
  final DateTime lastUpdate;
  final List<MachineEvent> events;

  const MachineData({
    required this.machineId,
    required this.currentNiveau,
    required this.lastUpdate,
    required this.events,
  });

  factory MachineData.fromJson(String machineId, Map<String, dynamic> json) {
    final eventsData = json['events'];
    final events = <MachineEvent>[];
    
    if (eventsData is Map) {
      try {
        final eventsMap = Map<String, dynamic>.from(eventsData);
        for (final entry in eventsMap.entries) {
          try {
            if (entry.value is Map) {
              final eventData = Map<String, dynamic>.from(entry.value);
              events.add(MachineEvent.fromJson(entry.key, eventData));
            }
          } catch (e) {
            // Ignorer les événements malformés
            print('Erreur parsing event ${entry.key}: $e');
          }
        }
      } catch (e) {
        print('Erreur parsing events: $e');
      }
    }
    
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return MachineData(
      machineId: machineId,
      currentNiveau: json['niveau'] as String? ?? 'UNKNOWN',
      lastUpdate: json['ts'] != null 
          ? DateTime.parse(json['ts'] as String)
          : DateTime.now(),
      events: events,
    );
  }

  Map<String, dynamic> toJson() {
    final eventsMap = <String, Map<String, dynamic>>{};
    for (final event in events) {
      eventsMap[event.id] = event.toJson();
    }

    return {
      'niveau': currentNiveau,
      'ts': lastUpdate.toIso8601String(),
      'events': eventsMap,
    };
  }

  MachineData copyWith({
    String? machineId,
    String? currentNiveau,
    DateTime? lastUpdate,
    List<MachineEvent>? events,
  }) {
    return MachineData(
      machineId: machineId ?? this.machineId,
      currentNiveau: currentNiveau ?? this.currentNiveau,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      events: events ?? this.events,
    );
  }

  @override
  String toString() {
    return 'MachineData(machineId: $machineId, currentNiveau: $currentNiveau, lastUpdate: $lastUpdate, events: ${events.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MachineData &&
        other.machineId == machineId &&
        other.currentNiveau == currentNiveau &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode => machineId.hashCode ^ currentNiveau.hashCode ^ lastUpdate.hashCode;
}
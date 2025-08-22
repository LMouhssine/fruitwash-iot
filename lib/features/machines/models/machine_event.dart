class MachineEvent {
  final String id;
  final String niveau;
  final DateTime timestamp;

  const MachineEvent({
    required this.id,
    required this.niveau,
    required this.timestamp,
  });

  factory MachineEvent.fromJson(String id, Map<String, dynamic> json) {
    return MachineEvent(
      id: id,
      niveau: json['niveau'] as String,
      timestamp: DateTime.parse(json['ts'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveau': niveau,
      'ts': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MachineEvent(id: $id, niveau: $niveau, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MachineEvent &&
        other.id == id &&
        other.niveau == niveau &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => id.hashCode ^ niveau.hashCode ^ timestamp.hashCode;
}
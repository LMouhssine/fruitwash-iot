enum DeviceType {
  washer,
  dryer,
  dishwasher,
  unknown;
  
  String get displayName {
    switch (this) {
      case DeviceType.washer:
        return 'Lave-linge';
      case DeviceType.dryer:
        return 'Sèche-linge';
      case DeviceType.dishwasher:
        return 'Lave-vaisselle';
      case DeviceType.unknown:
        return 'Inconnu';
    }
  }
}

enum DeviceStatus {
  offline,
  idle,
  running,
  paused,
  completed,
  error;
  
  String get displayName {
    switch (this) {
      case DeviceStatus.offline:
        return 'Hors ligne';
      case DeviceStatus.idle:
        return 'Inactif';
      case DeviceStatus.running:
        return 'En cours';
      case DeviceStatus.paused:
        return 'En pause';
      case DeviceStatus.completed:
        return 'Terminé';
      case DeviceStatus.error:
        return 'Erreur';
    }
  }
}

class DeviceModel {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final DateTime lastSeen;
  final String? firmwareVersion;
  final Map<String, dynamic>? settings;
  final double? batteryLevel;
  final String? currentProgram;
  final Duration? remainingTime;
  final DateTime? lastMaintenance;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.lastSeen,
    this.firmwareVersion,
    this.settings,
    this.batteryLevel,
    this.currentProgram,
    this.remainingTime,
    this.lastMaintenance,
  });

  bool get isOnline => status != DeviceStatus.offline;
  bool get isActive => status == DeviceStatus.running || status == DeviceStatus.paused;
  bool get needsMaintenance {
    if (lastMaintenance == null) return true;
    final daysSinceMaintenance = DateTime.now().difference(lastMaintenance!).inDays;
    return daysSinceMaintenance > 30; // 30 jours
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    DeviceType? type,
    DeviceStatus? status,
    DateTime? lastSeen,
    String? firmwareVersion,
    Map<String, dynamic>? settings,
    double? batteryLevel,
    String? currentProgram,
    Duration? remainingTime,
    DateTime? lastMaintenance,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      settings: settings ?? this.settings,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      currentProgram: currentProgram ?? this.currentProgram,
      remainingTime: remainingTime ?? this.remainingTime,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: DeviceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DeviceType.unknown,
      ),
      status: DeviceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeviceStatus.offline,
      ),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      firmwareVersion: json['firmwareVersion'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
      batteryLevel: (json['batteryLevel'] as num?)?.toDouble(),
      currentProgram: json['currentProgram'] as String?,
      remainingTime: json['remainingTime'] != null 
          ? Duration(seconds: json['remainingTime'] as int)
          : null,
      lastMaintenance: json['lastMaintenance'] != null 
          ? DateTime.parse(json['lastMaintenance'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'status': status.name,
      'lastSeen': lastSeen.toIso8601String(),
      if (firmwareVersion != null) 'firmwareVersion': firmwareVersion,
      if (settings != null) 'settings': settings,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (currentProgram != null) 'currentProgram': currentProgram,
      if (remainingTime != null) 'remainingTime': remainingTime!.inSeconds,
      if (lastMaintenance != null) 'lastMaintenance': lastMaintenance!.toIso8601String(),
    };
  }
}
enum WashCycleType {
  quick,
  normal,
  delicate,
  heavy,
  eco,
  custom;
  
  String get displayName {
    switch (this) {
      case WashCycleType.quick:
        return 'Cycle rapide';
      case WashCycleType.normal:
        return 'Cycle normal';
      case WashCycleType.delicate:
        return 'Cycle délicat';
      case WashCycleType.heavy:
        return 'Cycle intensif';
      case WashCycleType.eco:
        return 'Cycle éco';
      case WashCycleType.custom:
        return 'Cycle personnalisé';
    }
  }
  
  Duration get estimatedDuration {
    switch (this) {
      case WashCycleType.quick:
        return const Duration(minutes: 30);
      case WashCycleType.normal:
        return const Duration(minutes: 60);
      case WashCycleType.delicate:
        return const Duration(minutes: 45);
      case WashCycleType.heavy:
        return const Duration(minutes: 90);
      case WashCycleType.eco:
        return const Duration(minutes: 120);
      case WashCycleType.custom:
        return const Duration(minutes: 60);
    }
  }
}

enum WashCycleStatus {
  scheduled,
  running,
  paused,
  completed,
  failed,
  cancelled;
  
  String get displayName {
    switch (this) {
      case WashCycleStatus.scheduled:
        return 'Programmé';
      case WashCycleStatus.running:
        return 'En cours';
      case WashCycleStatus.paused:
        return 'En pause';
      case WashCycleStatus.completed:
        return 'Terminé';
      case WashCycleStatus.failed:
        return 'Échec';
      case WashCycleStatus.cancelled:
        return 'Annulé';
    }
  }
}

class WashCycleModel {
  final String id;
  final String deviceId;
  final WashCycleType type;
  final WashCycleStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Duration estimatedDuration;
  final Duration? actualDuration;
  final int temperature;
  final int spinSpeed;
  final Map<String, dynamic>? customSettings;
  final String? errorMessage;

  const WashCycleModel({
    required this.id,
    required this.deviceId,
    required this.type,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.estimatedDuration,
    this.actualDuration,
    required this.temperature,
    required this.spinSpeed,
    this.customSettings,
    this.errorMessage,
  });

  Duration? get remainingTime {
    if (startedAt == null || status != WashCycleStatus.running) return null;
    
    final elapsed = DateTime.now().difference(startedAt!);
    final remaining = estimatedDuration - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get progressPercentage {
    if (startedAt == null || status != WashCycleStatus.running) return 0.0;
    
    final elapsed = DateTime.now().difference(startedAt!);
    final progress = elapsed.inMilliseconds / estimatedDuration.inMilliseconds;
    
    return (progress * 100).clamp(0.0, 100.0);
  }

  WashCycleModel copyWith({
    String? id,
    String? deviceId,
    WashCycleType? type,
    WashCycleStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    Duration? estimatedDuration,
    Duration? actualDuration,
    int? temperature,
    int? spinSpeed,
    Map<String, dynamic>? customSettings,
    String? errorMessage,
  }) {
    return WashCycleModel(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      temperature: temperature ?? this.temperature,
      spinSpeed: spinSpeed ?? this.spinSpeed,
      customSettings: customSettings ?? this.customSettings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory WashCycleModel.fromJson(Map<String, dynamic> json) {
    return WashCycleModel(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      type: WashCycleType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WashCycleType.normal,
      ),
      status: WashCycleStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => WashCycleStatus.scheduled,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null 
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      estimatedDuration: Duration(seconds: json['estimatedDuration'] as int),
      actualDuration: json['actualDuration'] != null 
          ? Duration(seconds: json['actualDuration'] as int)
          : null,
      temperature: json['temperature'] as int,
      spinSpeed: json['spinSpeed'] as int,
      customSettings: json['customSettings'] as Map<String, dynamic>?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      'estimatedDuration': estimatedDuration.inSeconds,
      if (actualDuration != null) 'actualDuration': actualDuration!.inSeconds,
      'temperature': temperature,
      'spinSpeed': spinSpeed,
      if (customSettings != null) 'customSettings': customSettings,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }
}
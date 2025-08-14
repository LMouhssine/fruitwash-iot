class MockData {
  static const devices = [
    {'id': 'dev-001', 'name': 'Lave-Fruits #1', 'online': true},
    {'id': 'dev-002', 'name': 'Lave-Fruits #2', 'online': false},
  ];

  static const alerts = [
    {'title': 'Niveau d\'eau bas', 'deviceId': 'dev-001', 'severity': 'warning'},
    {'title': 'Maintenance requise', 'deviceId': 'dev-002', 'severity': 'info'},
  ];

  static const history = [
    {'deviceId': 'dev-001', 'date': '2025-08-12 10:30', 'duration': 8, 'water': 60},
    {'deviceId': 'dev-002', 'date': '2025-08-11 17:05', 'duration': 5, 'water': 50},
  ];
}



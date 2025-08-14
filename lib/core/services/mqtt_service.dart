class MqttService {
  Future<void> connect() async {}
  Future<void> publish(String topic, String payload) async {}
  Stream<String> subscribe(String topic) async* {}
}



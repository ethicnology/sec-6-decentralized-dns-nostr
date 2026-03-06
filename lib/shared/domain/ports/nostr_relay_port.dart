abstract class NostrRelayPort {
  Future<void> connect(List<String> relayUrls);
  Future<void> disconnect();
  Future<void> publish(Map<String, dynamic> event);
  Stream<Map<String, dynamic>> subscribe(Map<String, dynamic> filter);
  Future<void> unsubscribe(String subscriptionId);
}

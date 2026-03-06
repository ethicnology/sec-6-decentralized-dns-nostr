abstract class BlockchainPort {
  Future<void> connect();
  Future<void> connectTo(String host, int port);
  Future<void> disconnect();
  Future<int> getCurrentHeight();
  Future<List<Map<String, dynamic>>> getScriptHashHistory(String scriptHash);
  Future<Map<String, dynamic>> getTransaction(String txHash);
  String get currentHost;
  int get currentPort;
  bool get isConnected;
}

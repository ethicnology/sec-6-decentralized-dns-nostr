import 'package:nostr_namecoin/shared/domain/ports/blockchain_port.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/electrum_facade.dart';

class ElectrumBlockchainAdapter implements BlockchainPort {
  final ElectrumFacade _facade;

  ElectrumBlockchainAdapter(this._facade);

  @override
  Future<void> connect() =>
      _facade.connect(host: 'namecoin.stackwallet.com', port: 57002);

  @override
  Future<void> connectTo(String host, int port) =>
      _facade.connect(host: host, port: port);

  @override
  String get currentHost => _facade.host;

  @override
  int get currentPort => _facade.port;

  @override
  bool get isConnected => _facade.isConnected;

  @override
  Future<int> getCurrentHeight() async {
    final result = await _facade.request('blockchain.headers.subscribe', []);
    return result['height'] as int;
  }

  @override
  Future<List<Map<String, dynamic>>> getScriptHashHistory(
    String scriptHash,
  ) async {
    final result = await _facade.request(
      'blockchain.scripthash.get_history',
      [scriptHash],
    );
    return (result as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getTransaction(String txHash) =>
      _facade.getTransaction(txHash);

  @override
  Future<void> disconnect() => _facade.close();
}

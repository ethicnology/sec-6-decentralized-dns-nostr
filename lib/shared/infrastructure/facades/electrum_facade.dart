import 'dart:io';

import 'package:electrum_adapter/electrum_adapter.dart';

class ElectrumFacade {
  ElectrumClient? _client;
  String _host = 'namecoin.stackwallet.com';
  int _port = 57002;
  static const _maxRetries = 2;

  bool get isConnected => _client != null;
  String get host => _host;
  int get port => _port;

  bool _useSSL = false;

  Future<void> connect({
    required String host,
    required int port,
    bool useSSL = true,
  }) async {
    _host = host;
    _port = port;
    _useSSL = useSSL;
    await _ensureConnected();
  }

  Future<void> _ensureConnected() async {
    if (_client != null) return;
    try {
      _client = await ElectrumClient.connect(
        host: _host,
        port: _port,
        useSSL: _useSSL,
      );
      // ElectrumX requires server.version as the first call
      await _client!.request('server.version', ['nostr_namecoin', '1.4']);
    } on SocketException {
      _client = null;
      rethrow;
    }
  }

  Future<void> _reconnect() async {
    try {
      await _client?.close();
    } catch (_) {}
    _client = null;
    await _ensureConnected();
  }

  Future<dynamic> request(
    String method,
    List<dynamic> params, {
    int retries = _maxRetries,
  }) async {
    await _ensureConnected();
    try {
      return await _client!.request(method, params);
    } catch (e) {
      if (retries > 0) {
        await _reconnect();
        return request(method, params, retries: retries - 1);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTransaction(
    String txHash, {
    int retries = _maxRetries,
  }) async {
    await _ensureConnected();
    try {
      return await _client!.getTransaction(txHash);
    } catch (e) {
      if (retries > 0) {
        await _reconnect();
        return getTransaction(txHash, retries: retries - 1);
      }
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      await _client?.close();
    } catch (_) {}
    _client = null;
  }
}

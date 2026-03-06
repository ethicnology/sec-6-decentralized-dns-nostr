import 'dart:async';
import 'dart:convert';

import 'package:nostr_namecoin/shared/domain/ports/nostr_relay_port.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/nostr_facade.dart';

class NostrRelayAdapter implements NostrRelayPort {
  final NostrFacade _facade;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  NostrRelayAdapter(this._facade);

  @override
  Future<void> connect(List<String> relayUrls) async {
    // Connect to the first available relay for the PoC
    for (final url in relayUrls) {
      try {
        await _facade.connectRelay(url);
        // ignore: avoid_print
        print('[relay] connected to $url');
        _facade.stream?.listen((data) {
          final decoded = jsonDecode(data as String) as List<dynamic>;
          if (decoded[0] == 'EVENT' && decoded.length >= 3) {
            _messageController.add(
              Map<String, dynamic>.from(decoded[2] as Map),
            );
          }
        });
        return;
      } catch (e) {
        // ignore: avoid_print
        print('[relay] failed to connect to $url: $e');
        continue;
      }
    }
    throw Exception('Could not connect to any relay');
  }

  @override
  Future<void> disconnect() async {
    await _facade.disconnectRelay();
  }

  @override
  Future<void> publish(Map<String, dynamic> event) async {
    _facade.publish(event);
  }

  @override
  Stream<Map<String, dynamic>> subscribe(Map<String, dynamic> filter) {
    final subscriptionId =
        DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    _facade.subscribe(
      subscriptionId: subscriptionId,
      kinds: (filter['kinds'] as List<int>?),
      authors: (filter['authors'] as List<String>?),
      pTags: (filter['#p'] as List<String>?),
      since: filter['since'] as int?,
      limit: filter['limit'] as int?,
    );
    return _messageController.stream;
  }

  @override
  Future<void> unsubscribe(String subscriptionId) async {
    _facade.unsubscribe(subscriptionId);
  }
}

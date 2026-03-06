import 'dart:convert';
import 'dart:io';

import 'package:nostr/nostr.dart' as nostr;

class NostrFacade {
  // Keys

  ({String privateKeyHex, String publicKeyHex}) generateKeyPair() {
    final keys = nostr.Keys.generate();
    return (privateKeyHex: keys.secret, publicKeyHex: keys.public);
  }

  String publicKeyFromPrivate(String privateKeyHex) {
    return nostr.Keys(privateKeyHex).public;
  }

  String hexToNpub(String hexPubkey) {
    return nostr.Nip19.encode(prefix: nostr.Nip19Prefix.npub, data: hexPubkey);
  }

  String npubToHex(String npub) {
    final decoded = nostr.Nip19.decode(payload: npub);
    return decoded.data;
  }

  String nsecToHex(String nsec) {
    final decoded = nostr.Nip19.decode(payload: nsec);
    return decoded.data;
  }

  // NIP-17 Encrypted DMs

  Future<Map<String, dynamic>> encodeDirectMessage({
    required String message,
    required String senderPrivkeyHex,
    required String recipientPubkeyHex,
  }) async {
    final event = await nostr.Nip17.encode(
      message: message,
      authorPrivkey: senderPrivkeyHex,
      receiverPubkey: recipientPubkeyHex,
    );
    return event.toMap();
  }

  Future<Map<String, dynamic>> decodeDirectMessage({
    required Map<String, dynamic> giftWrapMap,
    required String recipientPrivkeyHex,
  }) async {
    final giftWrap = nostr.Event.fromMap(giftWrapMap, verify: false);
    final event = await nostr.Nip17.decode(
      giftWrap: giftWrap,
      receiverPrivkey: recipientPrivkeyHex,
    );
    return event.toMap();
  }

  // Relay communication

  WebSocket? _socket;

  Future<void> connectRelay(String url) async {
    _socket = await WebSocket.connect(url);
  }

  void publish(Map<String, dynamic> eventMap) {
    final serialized = jsonEncode(['EVENT', eventMap]);
    _socket?.add(serialized);
  }

  Stream<dynamic>? get stream => _socket;

  String subscribe({
    required String subscriptionId,
    List<int>? kinds,
    List<String>? authors,
    List<String>? pTags,
    int? since,
    int? limit,
  }) {
    final filter = <String, dynamic>{};
    if (kinds != null) filter['kinds'] = kinds;
    if (authors != null) filter['authors'] = authors;
    if (pTags != null) filter['#p'] = pTags;
    if (since != null) filter['since'] = since;
    if (limit != null) filter['limit'] = limit;

    // ignore: avoid_print
    print('[nostr] REQ $subscriptionId filter: $filter');
    final request = jsonEncode(['REQ', subscriptionId, filter]);
    _socket?.add(request);
    return subscriptionId;
  }

  void unsubscribe(String subscriptionId) {
    final close = jsonEncode(['CLOSE', subscriptionId]);
    _socket?.add(close);
  }

  Future<void> disconnectRelay() async {
    await _socket?.close();
    _socket = null;
  }
}

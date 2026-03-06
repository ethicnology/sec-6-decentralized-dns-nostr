import 'package:nostr_namecoin/shared/domain/entities/keypair_entity.dart';
import 'package:nostr_namecoin/shared/domain/ports/nostr_key_port.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/nostr_facade.dart';

class NostrKeyAdapter implements NostrKeyPort {
  final NostrFacade _facade;

  NostrKeyAdapter(this._facade);

  @override
  KeypairEntity generateKeyPair() {
    final pair = _facade.generateKeyPair();
    return KeypairEntity(
      privateKeyHex: pair.privateKeyHex,
      publicKeyHex: pair.publicKeyHex,
    );
  }

  @override
  String publicKeyFromPrivate(String privateKeyHex) =>
      _facade.publicKeyFromPrivate(privateKeyHex);

  @override
  String hexToNpub(String hexPubkey) => _facade.hexToNpub(hexPubkey);

  @override
  String npubToHex(String npub) => _facade.npubToHex(npub);

  @override
  String nsecToHex(String nsec) => _facade.nsecToHex(nsec);
}

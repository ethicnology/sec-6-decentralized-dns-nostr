import 'package:nostr_namecoin/shared/shared.dart';

abstract class NostrKeyPort {
  KeypairEntity generateKeyPair();
  String publicKeyFromPrivate(String privateKeyHex);
  String hexToNpub(String hexPubkey);
  String npubToHex(String npub);
  String nsecToHex(String nsec);
}

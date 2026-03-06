import 'package:nostr_namecoin/shared/shared.dart';

class ImportKeypairUseCase {
  final NostrKeyPort _nostrKeyPort;

  ImportKeypairUseCase(this._nostrKeyPort);

  /// Import from hex private key or nsec bech32 string.
  /// Always stores the private key as hex internally.
  KeypairEntity call(String secretKeyOrNsec) {
    final String privateKeyHex;
    if (secretKeyOrNsec.startsWith('nsec1')) {
      privateKeyHex = _nostrKeyPort.nsecToHex(secretKeyOrNsec);
    } else {
      privateKeyHex = secretKeyOrNsec;
    }
    final publicKeyHex = _nostrKeyPort.publicKeyFromPrivate(privateKeyHex);
    return KeypairEntity(
      privateKeyHex: privateKeyHex,
      publicKeyHex: publicKeyHex,
    );
  }
}

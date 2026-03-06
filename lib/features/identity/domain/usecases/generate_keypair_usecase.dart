import 'package:nostr_namecoin/shared/shared.dart';

class GenerateKeypairUseCase {
  final NostrKeyPort _nostrKeyPort;

  GenerateKeypairUseCase(this._nostrKeyPort);

  KeypairEntity call() => _nostrKeyPort.generateKeyPair();
}

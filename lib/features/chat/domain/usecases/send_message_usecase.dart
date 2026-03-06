import 'package:nostr_namecoin/shared/infrastructure/facades/nostr_facade.dart';
import 'package:nostr_namecoin/shared/domain/ports/nostr_relay_port.dart';

class SendMessageUseCase {
  final NostrFacade _nostrFacade;
  final NostrRelayPort _nostrRelayPort;

  SendMessageUseCase(this._nostrFacade, this._nostrRelayPort);

  Future<void> call({
    required String message,
    required String senderPrivkeyHex,
    required String recipientPubkeyHex,
  }) async {
    final giftWrap = await _nostrFacade.encodeDirectMessage(
      message: message,
      senderPrivkeyHex: senderPrivkeyHex,
      recipientPubkeyHex: recipientPubkeyHex,
    );
    await _nostrRelayPort.publish(giftWrap);
  }
}

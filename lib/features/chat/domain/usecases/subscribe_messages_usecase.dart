import 'dart:async';

import 'package:nostr_namecoin/shared/infrastructure/facades/nostr_facade.dart';
import 'package:nostr_namecoin/shared/domain/ports/nostr_relay_port.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';

class SubscribeMessagesUseCase {
  final NostrFacade _nostrFacade;
  final NostrRelayPort _nostrRelayPort;

  SubscribeMessagesUseCase(this._nostrFacade, this._nostrRelayPort);

  Stream<DirectMessageEntity> call({
    required String recipientPrivkeyHex,
    required String recipientPubkeyHex,
  }) {
    final controller = StreamController<DirectMessageEntity>();

    final rawEvents = _nostrRelayPort.subscribe({
      'kinds': [1059], // Gift wrap events
      '#p': [recipientPubkeyHex],
    });

    rawEvents.listen(
      (eventMap) async {
        try {
          final decrypted = await _nostrFacade.decodeDirectMessage(
            giftWrapMap: eventMap,
            recipientPrivkeyHex: recipientPrivkeyHex,
          );
          final senderPubkey = decrypted['pubkey'] as String;
          controller.add(DirectMessageEntity(
            id: decrypted['id'] as String,
            senderPubkeyHex: senderPubkey,
            recipientPubkeyHex: recipientPubkeyHex,
            content: decrypted['content'] as String,
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              (decrypted['created_at'] as int) * 1000,
            ),
            isOutgoing: false,
          ));
        } catch (_) {
          // Skip events we can't decrypt
        }
      },
      onError: (e) => controller.addError(e),
    );

    return controller.stream;
  }
}

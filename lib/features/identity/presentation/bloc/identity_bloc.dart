import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/identity/domain/usecases/generate_keypair_usecase.dart';
import 'package:nostr_namecoin/features/identity/domain/usecases/import_keypair_usecase.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_event.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';

class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  final GenerateKeypairUseCase _generateKeypairUseCase;
  final ImportKeypairUseCase _importKeypairUseCase;
  final NostrKeyPort _nostrKeyPort;
  final NostrRelayPort _nostrRelayPort;
  final NostrFacade _nostrFacade;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  IdentityBloc(
    this._generateKeypairUseCase,
    this._importKeypairUseCase,
    this._nostrKeyPort,
    this._nostrRelayPort,
    this._nostrFacade,
  ) : super(IdentityInitialState()) {
    on<GenerateKeypairRequestedEvent>(_onGenerate);
    on<ImportKeypairRequestedEvent>(_onImport);
    on<ConnectRelayEvent>(_onConnectRelay);
    on<DisconnectRelayEvent>(_onDisconnectRelay);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<RegisterContactNameEvent>(_onRegisterContactName);
  }

  Future<void> _subscribeToMessages(KeypairEntity keypair) async {
    await _messageSubscription?.cancel();

    // ignore: avoid_print
    print('[nostr] subscribing to kind:1059 for ${keypair.publicKeyHex}');

    final stream = _nostrRelayPort.subscribe({
      'kinds': [1059],
      '#p': [keypair.publicKeyHex],
    });

    _messageSubscription = stream.listen((eventMap) async {
      try {
        // ignore: avoid_print
        print('[nostr] received kind:1059 event');
        final decoded = await _nostrFacade.decodeDirectMessage(
          giftWrapMap: eventMap,
          recipientPrivkeyHex: keypair.privateKeyHex,
        );

        // NIP-17 structure:
        // Gift wrap (kind 1059) → Seal (kind 13) → Rumor (kind 14)
        // decoded = the inner rumor event
        // rumor.pubkey = actual author of the message
        // rumor.tags[p] = the intended recipient of the message
        //
        // Two copies are sent: one to recipient (#p=recipient), one to sender (#p=sender)
        // So for OUR sent messages echoed back: rumor.pubkey=us, rumor.tags[p]=us
        // We need the gift wrap's actual #p to distinguish, but we don't have it here.
        //
        // Instead: if rumor.pubkey == me AND rumor.tags[p] == me, this is our own
        // sent copy. The real recipient is in the OTHER copy we don't see.
        // We must look at the gift wrap's sender to find the conversation partner.

        final senderPubkey = decoded['pubkey'] as String? ?? 'unknown';

        // Skip our own sent copies — NIP-17 echoes them back but
        // with p tag = us, so we can't determine the real recipient.
        // Outgoing messages are added locally when sent via ChatPage.
        if (senderPubkey == keypair.publicKeyHex) {
          return;
        }

        final message = DirectMessageEntity(
          id:
              decoded['id'] as String? ??
              DateTime.now().microsecondsSinceEpoch.toRadixString(36),
          senderPubkeyHex: senderPubkey,
          recipientPubkeyHex: keypair.publicKeyHex,
          content: decoded['content'] as String? ?? '',
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            ((decoded['created_at'] as int?) ?? 0) * 1000,
          ),
          isOutgoing: false,
        );

        // ignore: avoid_print
        print(
          '[nostr] DM: from=${senderPubkey.substring(0, 12)}... '
          'content="${message.content}"',
        );
        add(MessageReceivedEvent(message));
      } catch (e) {
        // Can't decrypt = not for us, silently skip
      }
    });
  }

  void _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<IdentityState> emit,
  ) {
    final current = state;
    if (current is! IdentityLoadedState) return;
    final msg = event.message as DirectMessageEntity;
    emit(current.copyWith(messages: [...current.messages, msg]));
  }

  void addOutgoingMessage(DirectMessageEntity msg) {
    add(MessageReceivedEvent(msg));
  }

  void _onRegisterContactName(
    RegisterContactNameEvent event,
    Emitter<IdentityState> emit,
  ) {
    final current = state;
    if (current is! IdentityLoadedState) return;
    emit(
      current.copyWith(
        contactNames: {
          ...current.contactNames,
          event.pubkeyHex: event.displayName,
        },
      ),
    );
  }

  Future<void> _onGenerate(
    GenerateKeypairRequestedEvent event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      final keypair = _generateKeypairUseCase.call();
      final npub = _nostrKeyPort.hexToNpub(keypair.publicKeyHex);

      bool connected = false;
      if (event.relayUrl != null && event.relayUrl!.isNotEmpty) {
        try {
          await _nostrRelayPort.connect([event.relayUrl!]);
          connected = true;
        } catch (_) {}
      }

      emit(
        IdentityLoadedState(
          keypair: keypair,
          npub: npub,
          relayUrl: event.relayUrl,
          relayConnected: connected,
        ),
      );

      if (connected) await _subscribeToMessages(keypair);
    } catch (e) {
      emit(IdentityErrorState(e.toString()));
    }
  }

  Future<void> _onImport(
    ImportKeypairRequestedEvent event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      final keypair = _importKeypairUseCase.call(event.secretKeyOrNsec);
      final npub = _nostrKeyPort.hexToNpub(keypair.publicKeyHex);

      bool connected = false;
      if (event.relayUrl != null && event.relayUrl!.isNotEmpty) {
        try {
          await _nostrRelayPort.connect([event.relayUrl!]);
          connected = true;
        } catch (_) {}
      }

      emit(
        IdentityLoadedState(
          keypair: keypair,
          npub: npub,
          relayUrl: event.relayUrl,
          relayConnected: connected,
        ),
      );

      if (connected) await _subscribeToMessages(keypair);
    } catch (e) {
      emit(IdentityErrorState(e.toString()));
    }
  }

  Future<void> _onConnectRelay(
    ConnectRelayEvent event,
    Emitter<IdentityState> emit,
  ) async {
    final current = state;
    if (current is! IdentityLoadedState) return;

    try {
      await _nostrRelayPort.disconnect();
    } catch (_) {}
    await _messageSubscription?.cancel();

    try {
      await _nostrRelayPort.connect([event.relayUrl]);
      emit(current.copyWith(relayUrl: event.relayUrl, relayConnected: true));
      await _subscribeToMessages(current.keypair);
    } catch (e) {
      emit(current.copyWith(relayUrl: event.relayUrl, relayConnected: false));
    }
  }

  Future<void> _onDisconnectRelay(
    DisconnectRelayEvent event,
    Emitter<IdentityState> emit,
  ) async {
    final current = state;
    if (current is! IdentityLoadedState) return;

    await _messageSubscription?.cancel();
    try {
      await _nostrRelayPort.disconnect();
    } catch (_) {}

    emit(current.copyWith(relayConnected: false));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}

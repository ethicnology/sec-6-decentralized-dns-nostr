import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';
import 'package:nostr_namecoin/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:nostr_namecoin/features/chat/domain/usecases/subscribe_messages_usecase.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/chat/presentation/bloc/chat_event.dart';
import 'package:nostr_namecoin/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final SubscribeMessagesUseCase _subscribeMessagesUseCase;
  final NostrRelayPort _nostrRelayPort;
  final IdentityBloc _identityBloc;
  StreamSubscription<DirectMessageEntity>? _messageSubscription;

  ChatBloc(
    this._sendMessageUseCase,
    this._subscribeMessagesUseCase,
    this._nostrRelayPort,
    this._identityBloc,
  ) : super(const ChatState()) {
    on<ChatOpenedEvent>(_onChatOpened);
    on<SendMessageRequestedEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<ChatClosedEvent>(_onChatClosed);
  }

  Future<void> _onChatOpened(
    ChatOpenedEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      recipientPubkeyHex: event.recipientPubkeyHex,
      recipientRelays: event.relays,
      status: ChatStatus.connecting,
    ));

    try {
      await _nostrRelayPort.connect(event.relays);

      final identityState = _identityBloc.state;
      if (identityState is IdentityLoadedState) {
        _messageSubscription = _subscribeMessagesUseCase
            .call(
              recipientPrivkeyHex: identityState.keypair.privateKeyHex,
              recipientPubkeyHex: identityState.keypair.publicKeyHex,
            )
            .listen((message) => add(MessageReceivedEvent(message)));
      }

      emit(state.copyWith(status: ChatStatus.connected));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessageRequestedEvent event,
    Emitter<ChatState> emit,
  ) async {
    final identityState = _identityBloc.state;
    if (identityState is! IdentityLoadedState) return;
    if (state.recipientPubkeyHex == null) return;

    try {
      await _sendMessageUseCase.call(
        message: event.content,
        senderPrivkeyHex: identityState.keypair.privateKeyHex,
        recipientPubkeyHex: state.recipientPubkeyHex!,
      );

      final outgoing = DirectMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        senderPubkeyHex: identityState.keypair.publicKeyHex,
        recipientPubkeyHex: state.recipientPubkeyHex!,
        content: event.content,
        timestamp: DateTime.now(),
        isOutgoing: true,
      );
      emit(state.copyWith(messages: [...state.messages, outgoing]));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: [...state.messages, event.message]));
  }

  Future<void> _onChatClosed(
    ChatClosedEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _messageSubscription?.cancel();
    await _nostrRelayPort.disconnect();
    emit(const ChatState());
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}

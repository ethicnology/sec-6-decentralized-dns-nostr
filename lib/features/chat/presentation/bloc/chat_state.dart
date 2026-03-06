import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';

enum ChatStatus { initial, connecting, connected, error }

class ChatState {
  final String? recipientPubkeyHex;
  final List<String> recipientRelays;
  final List<DirectMessageEntity> messages;
  final ChatStatus status;
  final String? errorMessage;

  const ChatState({
    this.recipientPubkeyHex,
    this.recipientRelays = const [],
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  ChatState copyWith({
    String? recipientPubkeyHex,
    List<String>? recipientRelays,
    List<DirectMessageEntity>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      recipientPubkeyHex: recipientPubkeyHex ?? this.recipientPubkeyHex,
      recipientRelays: recipientRelays ?? this.recipientRelays,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

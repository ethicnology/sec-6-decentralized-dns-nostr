import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';

sealed class ChatEvent {}

class ChatOpenedEvent extends ChatEvent {
  final String recipientPubkeyHex;
  final List<String> relays;
  ChatOpenedEvent({required this.recipientPubkeyHex, required this.relays});
}

class SendMessageRequestedEvent extends ChatEvent {
  final String content;
  SendMessageRequestedEvent(this.content);
}

class MessageReceivedEvent extends ChatEvent {
  final DirectMessageEntity message;
  MessageReceivedEvent(this.message);
}

class ChatClosedEvent extends ChatEvent {}

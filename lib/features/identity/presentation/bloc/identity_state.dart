import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';

sealed class IdentityState {}

class IdentityInitialState extends IdentityState {}

class IdentityLoadedState extends IdentityState {
  final KeypairEntity keypair;
  final String npub;
  final String? relayUrl;
  final bool relayConnected;
  final List<DirectMessageEntity> messages;

  /// Maps pubkey hex → display name (e.g. "bob@nostr/bob")
  final Map<String, String> contactNames;

  IdentityLoadedState({
    required this.keypair,
    required this.npub,
    this.relayUrl,
    this.relayConnected = false,
    this.messages = const [],
    this.contactNames = const {},
  });

  IdentityLoadedState copyWith({
    String? relayUrl,
    bool? relayConnected,
    List<DirectMessageEntity>? messages,
    Map<String, String>? contactNames,
  }) {
    return IdentityLoadedState(
      keypair: keypair,
      npub: npub,
      relayUrl: relayUrl ?? this.relayUrl,
      relayConnected: relayConnected ?? this.relayConnected,
      messages: messages ?? this.messages,
      contactNames: contactNames ?? this.contactNames,
    );
  }
}

class IdentityErrorState extends IdentityState {
  final String message;
  IdentityErrorState(this.message);
}

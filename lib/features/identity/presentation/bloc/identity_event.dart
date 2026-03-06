sealed class IdentityEvent {}

class GenerateKeypairRequestedEvent extends IdentityEvent {
  final String? relayUrl;
  GenerateKeypairRequestedEvent({this.relayUrl});
}

class ImportKeypairRequestedEvent extends IdentityEvent {
  final String secretKeyOrNsec;
  final String? relayUrl;
  ImportKeypairRequestedEvent(this.secretKeyOrNsec, {this.relayUrl});
}

class ConnectRelayEvent extends IdentityEvent {
  final String relayUrl;
  ConnectRelayEvent(this.relayUrl);
}

class DisconnectRelayEvent extends IdentityEvent {}

class MessageReceivedEvent extends IdentityEvent {
  final dynamic message;
  MessageReceivedEvent(this.message);
}

class RegisterContactNameEvent extends IdentityEvent {
  final String pubkeyHex;
  final String displayName;
  RegisterContactNameEvent(this.pubkeyHex, this.displayName);
}

class LoadIdentityRequestedEvent extends IdentityEvent {}

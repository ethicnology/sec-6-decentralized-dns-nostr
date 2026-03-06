class DirectMessageEntity {
  final String id;
  final String senderPubkeyHex;
  final String recipientPubkeyHex;
  final String content;
  final DateTime timestamp;
  final bool isOutgoing;

  const DirectMessageEntity({
    required this.id,
    required this.senderPubkeyHex,
    required this.recipientPubkeyHex,
    required this.content,
    required this.timestamp,
    required this.isOutgoing,
  });

  @override
  String toString() =>
      'DirectMessageEntity(id: $id, isOutgoing: $isOutgoing, '
      'content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content})';
}

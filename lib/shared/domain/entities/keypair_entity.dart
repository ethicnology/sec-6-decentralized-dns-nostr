class KeypairEntity {
  final String privateKeyHex;
  final String publicKeyHex;

  const KeypairEntity({
    required this.privateKeyHex,
    required this.publicKeyHex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeypairEntity &&
          privateKeyHex == other.privateKeyHex &&
          publicKeyHex == other.publicKeyHex;

  @override
  int get hashCode => Object.hash(privateKeyHex, publicKeyHex);

  @override
  String toString() => 'KeypairEntity(publicKeyHex: $publicKeyHex)';
}

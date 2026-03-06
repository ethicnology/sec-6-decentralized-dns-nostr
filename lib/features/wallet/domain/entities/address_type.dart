enum AddressType {
  nativeSegwit, // BIP84 — nc1q... (P2WPKH)
  nestedSegwit, // BIP49 — M... (P2SH-P2WPKH)
  legacy, // BIP44 — N... (P2PKH)
}

extension AddressTypeExtension on AddressType {
  String get label => switch (this) {
        AddressType.nativeSegwit => 'Native Segwit (nc1q...)',
        AddressType.nestedSegwit => 'Nested Segwit (P2SH)',
        AddressType.legacy => 'Legacy (N...)',
      };

  String get bip => switch (this) {
        AddressType.nativeSegwit => 'BIP84',
        AddressType.nestedSegwit => 'BIP49',
        AddressType.legacy => 'BIP44',
      };

  int get purpose => switch (this) {
        AddressType.nativeSegwit => 84,
        AddressType.nestedSegwit => 49,
        AddressType.legacy => 44,
      };

  /// Account-level derivation path: m/purpose'/7'/0'
  String get accountPath => "m/$purpose'/7'/0'";
}

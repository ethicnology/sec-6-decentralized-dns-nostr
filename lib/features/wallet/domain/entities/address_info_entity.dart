class AddressInfoEntity {
  final String address;
  final String derivationPath;
  final int balance;
  final int utxoCount;
  final bool isChange;

  const AddressInfoEntity({
    required this.address,
    required this.derivationPath,
    required this.balance,
    required this.utxoCount,
    required this.isChange,
  });

  @override
  String toString() =>
      'AddressInfoEntity(address: $address, balance: $balance, '
      'utxoCount: $utxoCount, isChange: $isChange)';
}

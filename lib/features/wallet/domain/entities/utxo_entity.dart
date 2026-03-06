class UtxoEntity {
  final String txid;
  final int vout;
  final int value;

  const UtxoEntity({
    required this.txid,
    required this.vout,
    required this.value,
  });

  @override
  String toString() => 'UtxoEntity(txid: $txid, vout: $vout, value: $value)';
}

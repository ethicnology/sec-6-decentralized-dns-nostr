class TransactionEntity {
  final String txid;
  final int height;
  final int? amount;
  final bool isConfirmed;

  const TransactionEntity({
    required this.txid,
    required this.height,
    this.amount,
    required this.isConfirmed,
  });

  @override
  String toString() =>
      'TransactionEntity(txid: $txid, height: $height, '
      'amount: $amount, confirmed: $isConfirmed)';
}

import 'package:drift/drift.dart';

/// Cached raw transaction data from blockchain.transaction.get.
/// Confirmed txs are immutable — cache forever.
class CachedTransactions extends Table {
  TextColumn get txid => text()();
  TextColumn get rawJson => text()();
  IntColumn get height => integer().withDefault(const Constant(0))();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {txid};
}

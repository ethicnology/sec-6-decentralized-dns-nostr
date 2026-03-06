import 'package:drift/drift.dart';

/// Transaction history entries from blockchain.scripthash.get_history.
/// Tracks which txids belong to this wallet and their confirmation height.
class TransactionHistory extends Table {
  TextColumn get txid => text()();
  IntColumn get height => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {txid};
}

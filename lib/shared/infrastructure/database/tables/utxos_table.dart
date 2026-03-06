import 'package:drift/drift.dart';

import 'addresses_table.dart';

/// Unspent transaction outputs from blockchain.scripthash.listunspent.
/// Refreshed on every sync.
class Utxos extends Table {
  TextColumn get txid => text()();
  IntColumn get vout => integer()();
  IntColumn get value => integer()();
  TextColumn get address => text().references(Addresses, #address)();

  /// null = not yet checked, true = has nameOp, false = no nameOp
  BoolColumn get isNameUtxo => boolean().nullable()();
  TextColumn get nameOpType => text().nullable()();
  TextColumn get nameOpHash => text().nullable()();
  TextColumn get nameOpName => text().nullable()();
  TextColumn get nameOpValue => text().nullable()();

  @override
  Set<Column> get primaryKey => {txid, vout};
}

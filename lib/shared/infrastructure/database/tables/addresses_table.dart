import 'package:drift/drift.dart';

/// Derived HD wallet addresses with precomputed scriptHash.
/// Populated during syncAll() chain scan.
class Addresses extends Table {
  TextColumn get address => text()();
  IntColumn get chain => integer()();
  IntColumn get indexColumn => integer().named('idx')();
  TextColumn get derivationPath => text()();
  TextColumn get scriptHash => text()();
  BoolColumn get hasHistory => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {address};
}

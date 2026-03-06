import 'package:drift/drift.dart';

/// Pending name registrations. CRITICAL — prevents salt loss.
/// Persists through app restarts so name_firstupdate can always complete.
class PendingRegistrations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get saltHex => text()();
  TextColumn get commitmentHex => text()();
  TextColumn get nameNewTxid => text()();
  TextColumn get nameFirstUpdateTxid => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('pending_new'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

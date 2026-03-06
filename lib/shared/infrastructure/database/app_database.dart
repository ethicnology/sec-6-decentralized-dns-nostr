import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

import 'tables/addresses_table.dart';
import 'tables/utxos_table.dart';
import 'tables/cached_transactions_table.dart';
import 'tables/transaction_history_table.dart';
import 'tables/pending_registrations_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Addresses,
  Utxos,
  CachedTransactions,
  TransactionHistory,
  PendingRegistrations,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  static AppDatabase create() {
    return AppDatabase(_openConnection());
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'namecoin_wallet.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  // ── Addresses ──

  Future<void> upsertAddresses(List<AddressesCompanion> entries) {
    return batch((b) {
      for (final entry in entries) {
        b.insert(addresses, entry, onConflict: DoUpdate((_) => entry));
      }
    });
  }

  Future<List<AddressesData>> getUsedAddresses() {
    return (select(addresses)..where((a) => a.hasHistory.equals(true))).get();
  }

  Future<List<AddressesData>> getAllAddresses() => select(addresses).get();

  Future<AddressesData?> getAddressByString(String addr) {
    return (select(addresses)..where((a) => a.address.equals(addr)))
        .getSingleOrNull();
  }

  Future<int> getMaxUsedIndex(int chain) async {
    final query = selectOnly(addresses)
      ..addColumns([addresses.indexColumn.max()])
      ..where(
          addresses.chain.equals(chain) & addresses.hasHistory.equals(true));
    final row = await query.getSingleOrNull();
    return row?.read(addresses.indexColumn.max()) ?? -1;
  }

  // ── UTXOs ──

  Future<void> replaceUtxosForAddress(
      String addr, List<UtxosCompanion> newUtxos) {
    return transaction(() async {
      await (delete(utxos)..where((u) => u.address.equals(addr))).go();
      await batch((b) {
        for (final utxo in newUtxos) {
          b.insert(utxos, utxo);
        }
      });
    });
  }

  Future<List<Utxo>> getAllUtxos() => select(utxos).get();

  Future<List<Utxo>> getNonNameUtxos() {
    return (select(utxos)..where((u) => u.isNameUtxo.equals(false))).get();
  }

  Future<List<Utxo>> getUncheckedUtxos() {
    return (select(utxos)..where((u) => u.isNameUtxo.isNull())).get();
  }

  Future<Utxo?> getNameNewUtxoByCommitment(String commitmentHex) {
    return (select(utxos)
          ..where((u) =>
              u.isNameUtxo.equals(true) &
              u.nameOpType.equals('name_new') &
              u.nameOpHash.equals(commitmentHex)))
        .getSingleOrNull();
  }

  Future<Utxo?> getNameUtxoByName(String name) {
    return (select(utxos)
          ..where(
              (u) => u.isNameUtxo.equals(true) & u.nameOpName.equals(name)))
        .getSingleOrNull();
  }

  Future<void> markUtxoNameStatus({
    required String txid,
    required int vout,
    required bool isName,
    String? opType,
    String? opHash,
    String? opName,
    String? opValue,
  }) {
    return (update(utxos)
          ..where((u) => u.txid.equals(txid) & u.vout.equals(vout)))
        .write(UtxosCompanion(
      isNameUtxo: Value(isName),
      nameOpType: Value(opType),
      nameOpHash: Value(opHash),
      nameOpName: Value(opName),
      nameOpValue: Value(opValue),
    ));
  }

  Future<void> clearAllUtxos() => delete(utxos).go();

  // ── Cached Transactions ──

  Future<CachedTransaction?> getCachedTransaction(String txid) {
    return (select(cachedTransactions)..where((t) => t.txid.equals(txid)))
        .getSingleOrNull();
  }

  Future<void> cacheTransaction(String txid, String rawJson, int height) {
    return into(cachedTransactions).insertOnConflictUpdate(
      CachedTransactionsCompanion(
        txid: Value(txid),
        rawJson: Value(rawJson),
        height: Value(height),
        cachedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<CachedTransaction>> getCachedTransactions(List<String> txids) {
    return (select(cachedTransactions)..where((t) => t.txid.isIn(txids)))
        .get();
  }

  // ── Transaction History ──

  Future<void> replaceTransactionHistory(
      List<TransactionHistoryCompanion> entries) {
    return transaction(() async {
      await delete(transactionHistory).go();
      await batch((b) {
        for (final entry in entries) {
          b.insert(transactionHistory, entry);
        }
      });
    });
  }

  Future<List<TransactionHistoryData>> getTransactionHistorySorted() {
    return (select(transactionHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.height)]))
        .get();
  }

  // ── Pending Registrations ──

  Future<int> createPendingRegistration({
    required String name,
    required String saltHex,
    required String commitmentHex,
    required String nameNewTxid,
  }) {
    return into(pendingRegistrations).insert(PendingRegistrationsCompanion(
      name: Value(name),
      saltHex: Value(saltHex),
      commitmentHex: Value(commitmentHex),
      nameNewTxid: Value(nameNewTxid),
      status: const Value('pending_new'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<PendingRegistration?> getPendingRegistrationByName(String name) {
    return (select(pendingRegistrations)
          ..where((r) =>
              r.name.equals(name) &
              r.status.isIn(['pending_new', 'pending_firstupdate'])))
        .getSingleOrNull();
  }

  Future<List<PendingRegistration>> getAllPendingRegistrations() {
    return (select(pendingRegistrations)
          ..where(
              (r) => r.status.isIn(['pending_new', 'pending_firstupdate']))
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
        .get();
  }

  Future<void> markRegistrationCompleted(int id, String firstUpdateTxid) {
    return (update(pendingRegistrations)..where((r) => r.id.equals(id)))
        .write(PendingRegistrationsCompanion(
      nameFirstUpdateTxid: Value(firstUpdateTxid),
      status: const Value('completed'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> markRegistrationFailed(int id) {
    return (update(pendingRegistrations)..where((r) => r.id.equals(id)))
        .write(PendingRegistrationsCompanion(
      status: const Value('failed'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ── Bulk Operations ──

  Future<void> clearWalletData() {
    return transaction(() async {
      await delete(utxos).go();
      await delete(addresses).go();
      await delete(cachedTransactions).go();
      await delete(transactionHistory).go();
      // Do NOT delete pending_registrations — needed across wallet resets
    });
  }
}

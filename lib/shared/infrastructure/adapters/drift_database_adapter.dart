import 'package:nostr_namecoin/shared/domain/ports/database_port.dart';
import 'package:nostr_namecoin/shared/domain/entities/keypair_entity.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/pending_registration_entity.dart';
import 'package:nostr_namecoin/shared/infrastructure/database/app_database.dart';

class DriftDatabaseAdapter implements DatabasePort {
  final AppDatabase _db;

  DriftDatabaseAdapter(this._db);

  // ── Identity (not yet implemented) ──

  @override
  Future<void> saveIdentity(KeypairEntity keypair) async {
    // TODO: implement when identity tables are added
  }

  @override
  Future<KeypairEntity?> getIdentity() async => null;

  // ── Messages (not yet implemented) ──

  @override
  Future<void> saveMessage(DirectMessageEntity message) async {
    // TODO: implement when message tables are added
  }

  @override
  Future<List<DirectMessageEntity>> getMessages(
          String contactPubkeyHex) async =>
      [];

  // ── Name cache (not yet implemented) ──

  @override
  Future<void> cacheResolvedName(ResolveResultEntity result) async {
    // TODO: implement when name cache tables are added
  }

  @override
  Future<ResolveResultEntity?> getCachedName(String fullname) async => null;

  // ── Pending Registrations ──

  @override
  Future<int> createPendingRegistration({
    required String name,
    required String saltHex,
    required String commitmentHex,
    required String nameNewTxid,
  }) =>
      _db.createPendingRegistration(
        name: name,
        saltHex: saltHex,
        commitmentHex: commitmentHex,
        nameNewTxid: nameNewTxid,
      );

  @override
  Future<PendingRegistrationEntity?> getPendingRegistration(
      String name) async {
    final row = await _db.getPendingRegistrationByName(name);
    if (row == null) return null;
    return PendingRegistrationEntity(
      id: row.id,
      name: row.name,
      saltHex: row.saltHex,
      commitmentHex: row.commitmentHex,
      nameNewTxid: row.nameNewTxid,
      nameFirstUpdateTxid: row.nameFirstUpdateTxid,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Future<List<PendingRegistrationEntity>> getAllPendingRegistrations() async {
    final rows = await _db.getAllPendingRegistrations();
    return rows
        .map((row) => PendingRegistrationEntity(
              id: row.id,
              name: row.name,
              saltHex: row.saltHex,
              commitmentHex: row.commitmentHex,
              nameNewTxid: row.nameNewTxid,
              nameFirstUpdateTxid: row.nameFirstUpdateTxid,
              status: row.status,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ))
        .toList();
  }

  @override
  Future<void> markRegistrationCompleted(int id, String firstUpdateTxid) =>
      _db.markRegistrationCompleted(id, firstUpdateTxid);

  @override
  Future<void> markRegistrationFailed(int id) =>
      _db.markRegistrationFailed(id);
}

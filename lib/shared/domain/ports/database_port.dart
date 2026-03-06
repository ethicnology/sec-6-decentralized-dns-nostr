import 'package:nostr_namecoin/shared/domain/entities/keypair_entity.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/pending_registration_entity.dart';

abstract class DatabasePort {
  Future<void> saveIdentity(KeypairEntity keypair);
  Future<KeypairEntity?> getIdentity();

  Future<void> saveMessage(DirectMessageEntity message);
  Future<List<DirectMessageEntity>> getMessages(String contactPubkeyHex);

  Future<void> cacheResolvedName(ResolveResultEntity result);
  Future<ResolveResultEntity?> getCachedName(String fullname);

  // Pending name registrations
  Future<int> createPendingRegistration({
    required String name,
    required String saltHex,
    required String commitmentHex,
    required String nameNewTxid,
  });
  Future<PendingRegistrationEntity?> getPendingRegistration(String name);
  Future<List<PendingRegistrationEntity>> getAllPendingRegistrations();
  Future<void> markRegistrationCompleted(int id, String firstUpdateTxid);
  Future<void> markRegistrationFailed(int id);
}

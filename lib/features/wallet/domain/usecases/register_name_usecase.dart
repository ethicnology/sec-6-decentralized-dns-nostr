import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';
import 'package:nostr_namecoin/shared/domain/ports/database_port.dart';

class RegisterNameUseCase {
  final WalletPort _walletPort;
  final DatabasePort _databasePort;

  RegisterNameUseCase(this._walletPort, this._databasePort);

  /// Step 1: Broadcast name_new transaction. Returns txid and saltHex.
  /// Persists the registration so the salt survives app restarts.
  Future<({String txid, String saltHex})> nameNew(String name) async {
    final result = await _walletPort.buildNameNewTx(name);
    final txid = await _walletPort.broadcastTx(result.txHex);

    await _databasePort.createPendingRegistration(
      name: name,
      saltHex: result.saltHex,
      commitmentHex: result.commitmentHex,
      nameNewTxid: txid,
    );

    return (txid: txid, saltHex: result.saltHex);
  }

  /// Step 2: After 12 blocks, broadcast name_firstupdate transaction.
  /// Marks the registration as completed in the database.
  Future<String> nameFirstUpdate(
    String name,
    String value,
    String saltHex,
  ) async {
    final txHex = await _walletPort.buildNameFirstUpdateTx(
      name,
      value,
      saltHex,
    );
    final txid = await _walletPort.broadcastTx(txHex);

    final reg = await _databasePort.getPendingRegistration(name);
    if (reg != null) {
      await _databasePort.markRegistrationCompleted(reg.id, txid);
    }

    return txid;
  }
}

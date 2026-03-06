import 'package:nostr_namecoin/features/wallet/domain/entities/utxo_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/address_info_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/transaction_entity.dart';

abstract class WalletPort {
  String generateMnemonic();
  void importMnemonic(String mnemonic);
  bool get hasMnemonic;

  String getNextReceiveAddress();
  String getNextChangeAddress();
  Future<List<AddressInfoEntity>> getAddresses();

  Future<List<UtxoEntity>> getAllUtxos();
  Future<int> getTotalBalance();
  Future<List<TransactionEntity>> getTransactionHistory();

  /// Sync everything in one pass — addresses, UTXOs, balance, tx history.
  Future<({
    List<AddressInfoEntity> addresses,
    List<UtxoEntity> utxos,
    int totalBalance,
    List<TransactionEntity> transactions,
  })> syncAll();

  Future<({String txHex, String saltHex, String commitmentHex})>
      buildNameNewTx(String name);
  Future<String> buildNameFirstUpdateTx(String name, String value, String saltHex);
  Future<String> buildNameUpdateTx(String name, String value);
  Future<String> broadcastTx(String txHex);
  Future<String> sweepFromBip84();
}

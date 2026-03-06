import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/wallet_facade.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/utxo_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/address_info_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/transaction_entity.dart';

class WalletAdapter implements WalletPort {
  final WalletFacade _facade;

  WalletAdapter(this._facade);

  @override
  String generateMnemonic() => _facade.generateMnemonic();

  @override
  void importMnemonic(String mnemonic) => _facade.importMnemonic(mnemonic);

  @override
  bool get hasMnemonic => _facade.hasMnemonic;

  @override
  String getNextReceiveAddress() => _facade.getNextReceiveAddress();

  @override
  String getNextChangeAddress() => _facade.getNextChangeAddress();

  @override
  Future<List<AddressInfoEntity>> getAddresses() async {
    final raw = await _facade.getAddresses();
    return raw
        .map((a) => AddressInfoEntity(
              address: a.address,
              derivationPath: a.path,
              balance: a.balance,
              utxoCount: a.utxoCount,
              isChange: a.isChange,
            ))
        .toList();
  }

  @override
  Future<List<UtxoEntity>> getAllUtxos() async {
    final raw = await _facade.getAllUtxos();
    return raw
        .map((u) => UtxoEntity(txid: u.txid, vout: u.vout, value: u.value))
        .toList();
  }

  @override
  Future<int> getTotalBalance() => _facade.getTotalBalance();

  @override
  Future<List<TransactionEntity>> getTransactionHistory() async {
    final raw = await _facade.getTransactionHistory();
    return raw
        .map((t) => TransactionEntity(
              txid: t.txid,
              height: t.height,
              isConfirmed: t.height > 0,
            ))
        .toList();
  }

  @override
  Future<({
    List<AddressInfoEntity> addresses,
    List<UtxoEntity> utxos,
    int totalBalance,
    List<TransactionEntity> transactions,
  })> syncAll() async {
    final raw = await _facade.syncAll();
    return (
      addresses: raw.addresses
          .map((a) => AddressInfoEntity(
                address: a.address,
                derivationPath: a.path,
                balance: a.balance,
                utxoCount: a.utxoCount,
                isChange: a.isChange,
              ))
          .toList(),
      utxos: raw.utxos
          .map((u) => UtxoEntity(txid: u.txid, vout: u.vout, value: u.value))
          .toList(),
      totalBalance: raw.totalBalance,
      transactions: raw.transactions
          .map((t) => TransactionEntity(
                txid: t.txid,
                height: t.height,
                isConfirmed: t.height > 0,
              ))
          .toList(),
    );
  }

  @override
  Future<({String txHex, String saltHex, String commitmentHex})>
      buildNameNewTx(String name) => _facade.buildNameNewTx(name);

  @override
  Future<String> buildNameFirstUpdateTx(
          String name, String value, String saltHex) =>
      _facade.buildNameFirstUpdateTx(name, value, saltHex);

  @override
  Future<String> buildNameUpdateTx(String name, String value) =>
      _facade.buildNameUpdateTx(name, value);

  @override
  Future<String> broadcastTx(String txHex) => _facade.broadcastTx(txHex);

  @override
  Future<String> sweepFromBip84() => _facade.sweepFromBip84();
}

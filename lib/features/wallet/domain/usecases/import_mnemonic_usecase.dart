import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';

class ImportMnemonicUseCase {
  final WalletPort _walletPort;

  ImportMnemonicUseCase(this._walletPort);

  void call(String mnemonic) => _walletPort.importMnemonic(mnemonic);
}

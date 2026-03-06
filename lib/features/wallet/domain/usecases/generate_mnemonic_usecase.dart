import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';

class GenerateMnemonicUseCase {
  final WalletPort _walletPort;

  GenerateMnemonicUseCase(this._walletPort);

  String call() => _walletPort.generateMnemonic();
}

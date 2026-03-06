import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';

class GetBalanceUseCase {
  final WalletPort _walletPort;

  GetBalanceUseCase(this._walletPort);

  Future<int> call() => _walletPort.getTotalBalance();
}

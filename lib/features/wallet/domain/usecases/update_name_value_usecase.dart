import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';

class UpdateNameValueUseCase {
  final WalletPort _walletPort;

  UpdateNameValueUseCase(this._walletPort);

  Future<String> call(String name, String value) async {
    final txHex = await _walletPort.buildNameUpdateTx(name, value);
    return _walletPort.broadcastTx(txHex);
  }
}

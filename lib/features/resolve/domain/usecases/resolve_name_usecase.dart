import 'package:nostr_namecoin/shared/domain/ports/blockchain_port.dart';
import 'package:nostr_namecoin/shared/domain/ports/name_codec_port.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';

class ResolveNameUseCase {
  final BlockchainPort _blockchainPort;
  final NameCodecPort _nameCodecPort;

  ResolveNameUseCase(this._blockchainPort, this._nameCodecPort);

  Future<ResolveResultEntity?> call(String fullname) async {
    final scriptHash = _nameCodecPort.nameToScriptHash(fullname);
    final txs = await _blockchainPort.getScriptHashHistory(scriptHash);
    if (txs.isEmpty) return null;

    final latest = txs.last;
    final tx = await _blockchainPort.getTransaction(
      latest['tx_hash'] as String,
    );
    final currentHeight = await _blockchainPort.getCurrentHeight();
    return _nameCodecPort.parseTransaction(
      tx,
      latest['height'] as int,
      currentHeight,
    );
  }
}

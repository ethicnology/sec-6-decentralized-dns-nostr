import 'package:nostr_namecoin/shared/domain/entities/namecoin_value_entity.dart';
import 'package:nostr_namecoin/shared/domain/ports/name_codec_port.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/namecoin_facade.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';

class NamecoinNameAdapter implements NameCodecPort {
  final NamecoinFacade _facade;

  NamecoinNameAdapter(this._facade);

  @override
  String nameToScriptHash(String name) => _facade.nameToScriptHash(name);

  @override
  ResolveResultEntity parseTransaction(
    Map<String, dynamic> tx,
    int height,
    int currentHeight,
  ) {
    final opNameData = _facade.parseTransaction(tx, height);
    final isExpired = opNameData.expired(currentHeight);

    NamecoinValueEntity? value;
    try {
      final rawValue = opNameData.value;
      value = NamecoinValueEntity.fromJson(rawValue);
    } catch (_) {
      // Value not parseable — leave as null
    }

    return ResolveResultEntity(
      fullname: opNameData.fullname,
      constructedName: opNameData.constructedName,
      exists: true,
      value: value,
      isExpired: isExpired,
      blocksUntilExpiry: opNameData.expiredBlockLeft(currentHeight),
    );
  }

  @override
  ({String scriptHex, String saltHex}) buildNameNew(String name) {
    final result = _facade.buildNameNew(name);
    return (scriptHex: result.scriptHex, saltHex: result.saltHex);
  }

  @override
  String buildNameFirstUpdate(String name, String value, String salt) =>
      _facade.buildNameFirstUpdate(name, value, salt);

  @override
  String buildNameUpdate(String name, String value) =>
      _facade.buildNameUpdate(name, value);
}

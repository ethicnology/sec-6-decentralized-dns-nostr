import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';

abstract class NameCodecPort {
  String nameToScriptHash(String name);

  ResolveResultEntity parseTransaction(
    Map<String, dynamic> tx,
    int height,
    int currentHeight,
  );

  ({String scriptHex, String saltHex}) buildNameNew(String name);

  String buildNameFirstUpdate(String name, String value, String salt);

  String buildNameUpdate(String name, String value);
}

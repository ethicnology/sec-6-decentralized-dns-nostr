import 'package:namecoin/namecoin.dart' as nmc;

class NamecoinFacade {
  String nameToScriptHash(String name) {
    return nmc.nameIdentifierToScriptHash(name);
  }

  nmc.OpNameData parseTransaction(Map<String, dynamic> tx, int height) {
    return nmc.OpNameData.fromTx(tx, height);
  }

  ({String scriptHex, String saltHex, String commitmentHex}) buildNameNew(
    String name,
  ) {
    final (scriptHex, saltHex, commitmentHex) = nmc.scriptNameNew(name);
    return (
      scriptHex: scriptHex,
      saltHex: saltHex,
      commitmentHex: commitmentHex,
    );
  }

  String buildNameFirstUpdate(String name, String value, String saltHex) {
    return nmc.scriptNameFirstUpdate(name, value, saltHex);
  }

  String buildNameUpdate(String name, String value) {
    return nmc.scriptNameUpdate(name, value);
  }
}

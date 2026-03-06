import 'package:nostr_namecoin/shared/shared.dart';

class GetCurrentIdentityUseCase {
  final DatabasePort _databasePort;

  GetCurrentIdentityUseCase(this._databasePort);

  Future<KeypairEntity?> call() => _databasePort.getIdentity();
}

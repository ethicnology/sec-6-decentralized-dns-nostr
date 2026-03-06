import 'package:nostr_namecoin/shared/domain/entities/namecoin_value_entity.dart';

class ResolveResultEntity {
  final String fullname;
  final String constructedName;
  final bool exists;
  final NamecoinValueEntity? value;
  final bool isExpired;
  final int? blocksUntilExpiry;

  const ResolveResultEntity({
    required this.fullname,
    required this.constructedName,
    required this.exists,
    this.value,
    required this.isExpired,
    this.blocksUntilExpiry,
  });

  bool get isAvailable => !exists || isExpired;

  @override
  String toString() =>
      'ResolveResultEntity(fullname: $fullname, exists: $exists, '
      'isExpired: $isExpired, hasNostr: ${value?.hasNostr})';
}

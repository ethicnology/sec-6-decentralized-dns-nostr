import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';

class ResolveSearchEntity {
  final String query;
  final List<ResolveResultEntity> results;

  const ResolveSearchEntity({
    required this.query,
    required this.results,
  });
}

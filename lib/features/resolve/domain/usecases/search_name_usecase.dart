import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_search_entity.dart';
import 'package:nostr_namecoin/features/resolve/domain/usecases/resolve_name_usecase.dart';

class SearchNameUseCase {
  final ResolveNameUseCase _resolveNameUseCase;

  SearchNameUseCase(this._resolveNameUseCase);

  Future<ResolveSearchEntity> call(String query) async {
    final trimmed = query.trim().toLowerCase();

    // Resolve exactly what the user typed
    final fullname = trimmed;

    final result = await _resolveNameUseCase.call(fullname);
    return ResolveSearchEntity(
      query: trimmed,
      results: [
        result ??
            ResolveResultEntity(
              fullname: fullname,
              constructedName: fullname,
              exists: false,
              isExpired: false,
            ),
      ],
    );
  }
}

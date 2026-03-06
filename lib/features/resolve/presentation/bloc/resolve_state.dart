import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_search_entity.dart';

sealed class ResolveState {}

class ResolveInitialState extends ResolveState {}

class ResolveLoadingState extends ResolveState {}

class ResolveSuccessState extends ResolveState {
  final ResolveSearchEntity search;
  ResolveSuccessState(this.search);
}

class ResolveEmptyState extends ResolveState {
  final String query;
  ResolveEmptyState(this.query);
}

class ResolveErrorState extends ResolveState {
  final String message;
  ResolveErrorState(this.message);
}

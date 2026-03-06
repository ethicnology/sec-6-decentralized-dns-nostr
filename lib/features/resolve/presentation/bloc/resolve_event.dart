sealed class ResolveEvent {}

class SearchNameRequestedEvent extends ResolveEvent {
  final String query;
  SearchNameRequestedEvent(this.query);
}

class ResolveResetEvent extends ResolveEvent {}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/features/resolve/domain/usecases/search_name_usecase.dart';
import 'package:nostr_namecoin/features/resolve/presentation/bloc/resolve_event.dart';
import 'package:nostr_namecoin/features/resolve/presentation/bloc/resolve_state.dart';

class ResolveBloc extends Bloc<ResolveEvent, ResolveState> {
  final SearchNameUseCase _searchNameUseCase;

  ResolveBloc(this._searchNameUseCase) : super(ResolveInitialState()) {
    on<SearchNameRequestedEvent>(_onSearchRequested);
    on<ResolveResetEvent>(_onReset);
  }

  Future<void> _onSearchRequested(
    SearchNameRequestedEvent event,
    Emitter<ResolveState> emit,
  ) async {
    if (event.query.trim().isEmpty) return;

    emit(ResolveLoadingState());
    try {
      final search = await _searchNameUseCase.call(event.query);
      if (search.results.isEmpty) {
        emit(ResolveEmptyState(event.query));
      } else {
        emit(ResolveSuccessState(search));
      }
    } catch (e) {
      emit(ResolveErrorState(e.toString()));
    }
  }

  void _onReset(ResolveResetEvent event, Emitter<ResolveState> emit) {
    emit(ResolveInitialState());
  }
}

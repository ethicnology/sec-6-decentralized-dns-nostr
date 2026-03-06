import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/loading_indicator_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/name_result_card_widget.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:nostr_namecoin/features/resolve/presentation/bloc/resolve_bloc.dart';
import 'package:nostr_namecoin/features/resolve/presentation/bloc/resolve_event.dart';
import 'package:nostr_namecoin/features/resolve/presentation/bloc/resolve_state.dart';
import 'package:nostr_namecoin/features/chat/presentation/pages/chat_page.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_event.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/register_name_usecase.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/update_name_value_usecase.dart';
import 'package:nostr_namecoin/features/wallet/presentation/pages/register_name_page.dart';
import 'package:nostr_namecoin/features/wallet/presentation/pages/name_detail_page.dart';

class ResolvePage extends StatefulWidget {
  final RegisterNameUseCase registerNameUseCase;
  final UpdateNameValueUseCase updateNameValueUseCase;
  final DatabasePort databasePort;
  final NostrFacade nostrFacade;
  final NostrRelayPort nostrRelayPort;

  const ResolvePage({
    super.key,
    required this.registerNameUseCase,
    required this.updateNameValueUseCase,
    required this.databasePort,
    required this.nostrFacade,
    required this.nostrRelayPort,
  });

  @override
  State<ResolvePage> createState() => _ResolvePageState();
}

class _ResolvePageState extends State<ResolvePage> {
  final _controller = TextEditingController();
  final _nostrKeyPort = NostrKeyAdapter(NostrFacade());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Name (e.g. alice or d/alice)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ResolveBloc, ResolveState>(
              builder: (context, state) {
                return switch (state) {
                  ResolveInitialState() => const Center(
                      child: Text('Enter a name to search'),
                    ),
                  ResolveLoadingState() => const LoadingIndicatorWidget(
                      message: 'Searching across subspaces...',
                    ),
                  ResolveSuccessState(:final search) => ListView.builder(
                      itemCount: search.results.length,
                      itemBuilder: (context, index) {
                        final result = search.results[index];
                        return NameResultCardWidget(
                          result: result,
                          hexToNpub: _nostrKeyPort.hexToNpub,
                          onChat: (pubkeyHex, relays, contactName) =>
                              _openChat(pubkeyHex, relays, contactName),
                          onRegister: result.isAvailable
                              ? () => _openRegister(result.fullname)
                              : null,
                          onTap: result.exists
                              ? () => _openDetail(result)
                              : null,
                        );
                      },
                    ),
                  ResolveEmptyState(:final query) => Center(
                      child: Text('No results for "$query"'),
                    ),
                  ResolveErrorState(:final message) => ErrorCardWidget(
                      message: message,
                      onRetry: _search,
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    context.read<ResolveBloc>().add(
          SearchNameRequestedEvent(_controller.text),
        );
  }

  void _openChat(String pubkeyHex, List<String> relays, String contactName) {
    final identityBloc = context.read<IdentityBloc>();
    if (identityBloc.state is! IdentityLoadedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import your Nostr identity first (Nostr tab)'),
        ),
      );
      return;
    }
    identityBloc.add(RegisterContactNameEvent(pubkeyHex, contactName));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: identityBloc,
          child: ChatPage(
            recipientPubkeyHex: pubkeyHex,
            nostrFacade: widget.nostrFacade,
            nostrRelayPort: widget.nostrRelayPort,
            contactName: contactName,
          ),
        ),
      ),
    );
  }

  void _openDetail(ResolveResultEntity result) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<IdentityBloc>(),
          child: NameDetailPage(
            result: result,
            hexToNpub: _nostrKeyPort.hexToNpub,
            updateNameValueUseCase: widget.updateNameValueUseCase,
            nostrFacade: widget.nostrFacade,
            nostrRelayPort: widget.nostrRelayPort,
          ),
        ),
      ),
    );
  }

  void _openRegister(String fullname) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterNamePage(
          fullname: fullname,
          registerNameUseCase: widget.registerNameUseCase,
          databasePort: widget.databasePort,
        ),
      ),
    );
  }
}

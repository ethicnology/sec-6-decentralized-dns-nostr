import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_event.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final _importController = TextEditingController();

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityBloc, IdentityState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCardWidget(
                title: 'Nostr Identity',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state is! IdentityLoadedState) ...[
                      ElevatedButton(
                        onPressed: () => context
                            .read<IdentityBloc>()
                            .add(GenerateKeypairRequestedEvent()),
                        child: const Text('Generate New Keypair'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _importController,
                              decoration: const InputDecoration(
                                labelText: 'Or import nsec / hex private key',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () =>
                                context.read<IdentityBloc>().add(
                                      ImportKeypairRequestedEvent(
                                        _importController.text,
                                      ),
                                    ),
                            icon: const Icon(Icons.login),
                          ),
                        ],
                      ),
                    ],
                    if (state is IdentityLoadedState) ...[
                      CopyableFieldWidget(
                        label: 'Public key (hex)',
                        value: state.keypair.publicKeyHex,
                      ),
                      CopyableFieldWidget(label: 'npub', value: state.npub),
                      const SizedBox(height: 8),
                      CopyableFieldWidget(
                        label: 'Private key (hex)',
                        value: state.keypair.privateKeyHex,
                      ),
                    ],
                    if (state is IdentityErrorState)
                      ErrorCardWidget(message: state.message),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

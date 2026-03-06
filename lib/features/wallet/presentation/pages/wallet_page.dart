import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _importController = TextEditingController();
  bool _mnemonicVisible = false;

  int get _wordCount {
    final text = _importController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  bool get _isValidWordCount =>
      const {12, 15, 18, 21, 24}.contains(_wordCount);

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.mnemonic == null) _buildSetupSection(),
              if (state.mnemonic != null) ...[
                _buildMnemonicSection(state),
                _buildAddressSection(state),
                _buildBalanceSection(state),
                _buildSweepSection(),
                _buildTransactionHistorySection(),
              ],
              if (state.status == WalletStatus.error &&
                  state.errorMessage != null)
                ErrorCardWidget(message: state.errorMessage!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCardWidget(
          title: 'Create New Wallet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BIP44 Legacy (P2PKH)',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context
                    .read<WalletBloc>()
                    .add(GenerateMnemonicRequestedEvent()),
                child: const Text('Generate New Wallet'),
              ),
            ],
          ),
        ),
        SectionCardWidget(
          title: 'Import Existing Wallet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _importController,
                decoration: const InputDecoration(
                  labelText: 'BIP39 mnemonic (12 or 24 words)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                '$_wordCount words',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isValidWordCount
                          ? Colors.green
                          : Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isValidWordCount
                    ? () => context.read<WalletBloc>().add(
                          ImportMnemonicRequestedEvent(
                            _importController.text.trim(),
                          ),
                        )
                    : null,
                child: const Text('Import'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMnemonicSection(WalletState state) {
    return SectionCardWidget(
      title: 'Mnemonic',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _mnemonicVisible
                    ? Text(
                        state.mnemonic!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      )
                    : const Text(
                        'Tap the eye icon to reveal',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
              ),
              IconButton(
                icon: Icon(
                  _mnemonicVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _mnemonicVisible = !_mnemonicVisible),
              ),
            ],
          ),
          Text(
            "BIP44 Legacy (P2PKH) — m/44'/7'/0'",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(WalletState state) {
    return SectionCardWidget(
      title: 'Receive Address',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.address != null)
            CopyableFieldWidget(
              label: 'Current address',
              value: state.address!,
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context
                .read<WalletBloc>()
                .add(NewAddressRequestedEvent()),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(WalletState state) {
    return SectionCardWidget(
      title: 'Balance',
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.balanceDisplay,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (state.status == WalletStatus.loading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              onPressed: () => context
                  .read<WalletBloc>()
                  .add(RefreshBalanceRequestedEvent()),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
    );
  }

  Widget _buildSweepSection() {
    return SectionCardWidget(
      title: 'Migrate from Segwit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'If you have funds at BIP84 segwit addresses (nc1q...) from a '
            'previous session, sweep them to your BIP44 legacy address.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context
                .read<WalletBloc>()
                .add(SweepFromBip84RequestedEvent()),
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('Sweep BIP84 to BIP44'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return SectionCardWidget(
          title: 'Addresses & Transactions',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.addresses.isEmpty && state.transactions.isEmpty)
                Text(
                  'Tap refresh to scan addresses and load history.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

              // Addresses with balances
              if (state.addresses.isNotEmpty) ...[
                Text(
                  'Addresses (${state.addresses.length})',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                for (final addr in state.addresses)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          addr.isChange
                              ? Icons.swap_horiz
                              : Icons.arrow_downward,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SelectableText(
                            addr.address,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          '${(addr.balance / 100000000).toStringAsFixed(8)} NMC',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
              ],

              // Transaction history
              if (state.transactions.isNotEmpty) ...[
                Text(
                  'Transactions (${state.transactions.length})',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                for (final tx in state.transactions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          tx.isConfirmed
                              ? Icons.check_circle
                              : Icons.pending,
                          size: 14,
                          color: tx.isConfirmed
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SelectableText(
                            tx.txid,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (tx.height > 0 && state.currentHeight != null)
                          Text(
                            '${state.currentHeight! - tx.height + 1} conf',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        else if (tx.height <= 0)
                          Text(
                            'unconfirmed',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

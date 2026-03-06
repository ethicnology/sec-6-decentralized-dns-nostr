import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/domain/ports/blockchain_port.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_event.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';

class SettingsPage extends StatefulWidget {
  final BlockchainPort blockchainPort;

  const SettingsPage({super.key, required this.blockchainPort});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Wallet
  final _mnemonicImportController = TextEditingController();
  bool _mnemonicVisible = false;

  // Nostr identity
  final _nsecImportController = TextEditingController();
  final _relayController = TextEditingController(text: 'wss://nos.lol');

  // Electrum node
  late final TextEditingController _electrumHostController;
  late final TextEditingController _electrumPortController;

  int get _wordCount {
    final text = _mnemonicImportController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  bool get _isValidWordCount => const {12, 15, 18, 21, 24}.contains(_wordCount);

  @override
  void initState() {
    super.initState();
    _electrumHostController =
        TextEditingController(text: widget.blockchainPort.currentHost);
    _electrumPortController =
        TextEditingController(text: widget.blockchainPort.currentPort.toString());
  }

  @override
  void dispose() {
    _mnemonicImportController.dispose();
    _nsecImportController.dispose();
    _relayController.dispose();
    _electrumHostController.dispose();
    _electrumPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWalletSection(),
          const SizedBox(height: 16),
          _buildNostrIdentitySection(),
          const SizedBox(height: 16),
          _buildNostrRelaySection(),
          const SizedBox(height: 16),
          _buildElectrumSection(),
        ],
      ),
    );
  }

  // ── Wallet ──────────────────────────────────────────────────────────────────

  Widget _buildWalletSection() {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.mnemonic == null) ...[
              _buildWalletSetup(),
            ] else ...[
              _buildMnemonicCard(state),
              const SizedBox(height: 8),
              _buildAddressCard(state),
              const SizedBox(height: 8),
              _buildBalanceCard(state),
              const SizedBox(height: 8),
              _buildTxHistoryCard(state),
            ],
            if (state.status == WalletStatus.error &&
                state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ErrorCardWidget(message: state.errorMessage!),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWalletSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCardWidget(
          title: 'Namecoin Wallet',
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
        const SizedBox(height: 8),
        SectionCardWidget(
          title: 'Import Wallet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _mnemonicImportController,
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
                            _mnemonicImportController.text.trim(),
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

  Widget _buildMnemonicCard(WalletState state) {
    return SectionCardWidget(
      title: 'Namecoin Wallet',
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
                        'Tap the eye icon to reveal mnemonic',
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

  Widget _buildAddressCard(WalletState state) {
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
            onPressed: () =>
                context.read<WalletBloc>().add(NewAddressRequestedEvent()),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(WalletState state) {
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
              onPressed: () =>
                  context.read<WalletBloc>().add(RefreshBalanceRequestedEvent()),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
    );
  }

  Widget _buildTxHistoryCard(WalletState state) {
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
                      addr.isChange ? Icons.swap_horiz : Icons.arrow_downward,
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
                      tx.isConfirmed ? Icons.check_circle : Icons.pending,
                      size: 14,
                      color: tx.isConfirmed ? Colors.green : Colors.orange,
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
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.orange),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ── Nostr Identity ──────────────────────────────────────────────────────────

  Widget _buildNostrIdentitySection() {
    return BlocBuilder<IdentityBloc, IdentityState>(
      builder: (context, state) {
        return SectionCardWidget(
          title: 'Nostr Identity',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is! IdentityLoadedState) ...[
                ElevatedButton(
                  onPressed: () => context.read<IdentityBloc>().add(
                        GenerateKeypairRequestedEvent(
                          relayUrl: _relayController.text.trim(),
                        ),
                      ),
                  child: const Text('Generate New Keypair'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nsecImportController,
                        decoration: const InputDecoration(
                          labelText: 'Import nsec or hex private key',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => context.read<IdentityBloc>().add(
                            ImportKeypairRequestedEvent(
                              _nsecImportController.text,
                              relayUrl: _relayController.text.trim(),
                            ),
                          ),
                      icon: const Icon(Icons.login),
                      tooltip: 'Import',
                    ),
                  ],
                ),
              ],
              if (state is IdentityLoadedState) ...[
                CopyableFieldWidget(label: 'npub', value: state.npub),
                CopyableFieldWidget(
                  label: 'Public key (hex)',
                  value: state.keypair.publicKeyHex,
                ),
              ],
              if (state is IdentityErrorState)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ErrorCardWidget(message: state.message),
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Nostr Relay ─────────────────────────────────────────────────────────────

  Widget _buildNostrRelaySection() {
    return BlocBuilder<IdentityBloc, IdentityState>(
      builder: (context, state) {
        final loaded = state is IdentityLoadedState ? state : null;
        if (loaded?.relayUrl != null && _relayController.text.isEmpty) {
          _relayController.text = loaded!.relayUrl!;
        }
        return SectionCardWidget(
          title: 'Nostr Relay',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (loaded != null)
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: loaded.relayConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loaded.relayConnected
                            ? 'Connected to ${loaded.relayUrl}'
                            : loaded.relayUrl != null
                                ? 'Disconnected from ${loaded.relayUrl}'
                                : 'No relay configured',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              if (loaded != null) const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _relayController,
                      decoration: const InputDecoration(
                        labelText: 'Relay URL',
                        hintText: 'wss://nos.lol',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.cell_tower),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (loaded == null || !loaded.relayConnected)
                    IconButton(
                      onPressed: () => context.read<IdentityBloc>().add(
                            ConnectRelayEvent(_relayController.text.trim()),
                          ),
                      icon: const Icon(Icons.link),
                      tooltip: 'Connect',
                    )
                  else
                    IconButton(
                      onPressed: () => context
                          .read<IdentityBloc>()
                          .add(DisconnectRelayEvent()),
                      icon: const Icon(Icons.link_off),
                      tooltip: 'Disconnect',
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Electrum Node ───────────────────────────────────────────────────────────

  Widget _buildElectrumSection() {
    return SectionCardWidget(
      title: 'Namecoin Electrum Node',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 12,
                color: widget.blockchainPort.isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.blockchainPort.isConnected
                      ? 'Connected to ${widget.blockchainPort.currentHost}:${widget.blockchainPort.currentPort}'
                      : 'Disconnected',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _electrumHostController,
                  decoration: const InputDecoration(
                    labelText: 'Host',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _electrumPortController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _connectElectrum(),
            icon: const Icon(Icons.sync, size: 18),
            label: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectElectrum() async {
    final host = _electrumHostController.text.trim();
    final port = int.tryParse(_electrumPortController.text.trim());
    if (host.isEmpty || port == null || port < 1 || port > 65535) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid host or port')),
      );
      return;
    }
    await widget.blockchainPort.disconnect();
    try {
      await widget.blockchainPort.connectTo(host, port);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
      }
    }
  }
}

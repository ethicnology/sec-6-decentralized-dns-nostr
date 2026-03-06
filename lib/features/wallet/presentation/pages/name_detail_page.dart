import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/dns_record_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/nostr_identity_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/byte_counter_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/features/chat/presentation/pages/chat_page.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_event.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/update_name_value_usecase.dart';

class NameDetailPage extends StatefulWidget {
  final ResolveResultEntity result;
  final String Function(String hexPubkey)? hexToNpub;
  final UpdateNameValueUseCase? updateNameValueUseCase;
  final NostrFacade? nostrFacade;
  final NostrRelayPort? nostrRelayPort;

  const NameDetailPage({
    super.key,
    required this.result,
    this.hexToNpub,
    this.updateNameValueUseCase,
    this.nostrFacade,
    this.nostrRelayPort,
  });

  @override
  State<NameDetailPage> createState() => _NameDetailPageState();
}

class _NameDetailPageState extends State<NameDetailPage> {
  late final TextEditingController _valueController;
  bool _editing = false;
  bool _saving = false;
  String? _updateTxid;
  String? _error;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.result.value?.rawJson ?? '',
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.result.value;
    final colorScheme = Theme.of(context).colorScheme;

    final String statusLabel;
    final Color statusColor;
    if (!widget.result.exists) {
      statusLabel = 'Available';
      statusColor = Colors.green;
    } else if (widget.result.isExpired) {
      statusLabel = 'Expired';
      statusColor = colorScheme.error;
    } else {
      statusLabel = 'Active';
      statusColor = colorScheme.primary;
    }

    final valueText = _valueController.text;
    final byteLength = utf8.encode(valueText).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.result.fullname),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.result.blocksUntilExpiry != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Expires in ${widget.result.blocksUntilExpiry} blocks',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

            // DNS Records
            if (value != null && value.hasDns && !_editing)
              SectionCardWidget(
                title: 'DNS Records',
                child: Column(
                  children: [
                    if (value.ip != null)
                      DnsRecordFieldWidget(label: 'IPv4', value: value.ip!),
                    if (value.ip6 != null)
                      DnsRecordFieldWidget(label: 'IPv6', value: value.ip6!),
                    if (value.ns != null && value.ns!.isNotEmpty)
                      DnsRecordFieldWidget(
                          label: 'NS', value: value.ns!.join(', ')),
                    if (value.tor != null)
                      DnsRecordFieldWidget(label: 'TOR', value: value.tor!),
                    if (value.i2p != null)
                      DnsRecordFieldWidget(label: 'I2P', value: value.i2p!),
                    if (value.alias != null)
                      DnsRecordFieldWidget(
                          label: 'CNAME', value: value.alias!),
                    if (value.email != null)
                      DnsRecordFieldWidget(
                          label: 'Email', value: value.email!),
                  ],
                ),
              ),

            // Nostr Identities
            if (value != null && value.hasNostr && !_editing)
              SectionCardWidget(
                title: 'Nostr Identity (${value.nostrNames.length})',
                child: Column(
                  children: value.nostrNames.entries.map((entry) {
                    final address = NamecoinValueEntity.formatNostrAddress(
                      widget.result.fullname,
                      entry.key,
                    );
                    final relays = value.nostrRelays[entry.value] ?? [];
                    return NostrIdentityCardWidget(
                      address: address,
                      pubkeyHex: entry.value,
                      npub: widget.hexToNpub?.call(entry.value),
                      relays: relays,
                      onChat: widget.nostrFacade != null &&
                              widget.nostrRelayPort != null
                          ? () {
                              final identityBloc =
                                  context.read<IdentityBloc>();
                              if (identityBloc.state
                                  is! IdentityLoadedState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Import your Nostr identity first (Nostr tab)'),
                                  ),
                                );
                                return;
                              }
                              identityBloc.add(RegisterContactNameEvent(
                                  entry.value, address));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: identityBloc,
                                    child: ChatPage(
                                      recipientPubkeyHex: entry.value,
                                      nostrFacade: widget.nostrFacade!,
                                      nostrRelayPort: widget.nostrRelayPort!,
                                      contactName: address,
                                    ),
                                  ),
                                ),
                              );
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ),

            // Value editor
            SectionCardWidget(
              title: _editing ? 'Edit Value' : 'Value',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_editing) ...[
                    TextField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        labelText: 'JSON value',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 6,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 4),
                    ByteCounterWidget(current: byteLength),
                    if (byteLength > 520)
                      Text(
                        'Exceeds 520 byte limit',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _saving || byteLength > 520
                              ? null
                              : _saveValue,
                          child: _saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Save (name_update)'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => setState(() {
                            _editing = false;
                            _valueController.text =
                                widget.result.value?.rawJson ?? '';
                          }),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ] else ...[
                    if (value != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _prettyJson(value.rawJson),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (value != null) ...[
                      const SizedBox(height: 4),
                      ByteCounterWidget(current: value.byteLength),
                    ],
                    if (widget.result.exists &&
                        !widget.result.isExpired &&
                        widget.updateNameValueUseCase != null) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _editing = true),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit Value'),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            if (_updateTxid != null)
              SectionCardWidget(
                title: 'Value Updated',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 6),
                        Text('name_update broadcast successful'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CopyableFieldWidget(label: 'txid', value: _updateTxid!),
                  ],
                ),
              ),

            if (_error != null) ErrorCardWidget(message: _error!),

            if (value == null && widget.result.exists)
              const ErrorCardWidget(message: 'Could not parse name value'),

            if (!widget.result.exists)
              SectionCardWidget(
                title: 'Status',
                child: const Text('This name is not registered.'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveValue() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final txid = await widget.updateNameValueUseCase!.call(
        widget.result.fullname,
        _valueController.text.trim(),
      );
      setState(() {
        _updateTxid = txid;
        _saving = false;
        _editing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  String _prettyJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nostr_namecoin/shared/domain/ports/database_port.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/byte_counter_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/error_card_widget.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/register_name_usecase.dart';

class RegisterNamePage extends StatefulWidget {
  final String fullname;
  final RegisterNameUseCase registerNameUseCase;
  final DatabasePort databasePort;

  /// If provided, skip name_new and go straight to name_firstupdate
  final String? existingSalt;

  const RegisterNamePage({
    super.key,
    required this.fullname,
    required this.registerNameUseCase,
    required this.databasePort,
    this.existingSalt,
  });

  @override
  State<RegisterNamePage> createState() => _RegisterNamePageState();
}

class _RegisterNamePageState extends State<RegisterNamePage> {
  final _valueController = TextEditingController();
  final _saltController = TextEditingController();
  bool _loading = false;
  bool _dbChecked = false;
  bool _showManualSalt = false;
  String? _error;

  // Step 1: name_new
  String? _nameNewTxid;
  String? _saltHex;

  // Step 2: name_firstupdate
  String? _firstUpdateTxid;

  @override
  void initState() {
    super.initState();
    if (widget.existingSalt != null) {
      _saltHex = widget.existingSalt;
      _dbChecked = true;
    } else {
      _loadPendingRegistration();
    }
  }

  Future<void> _loadPendingRegistration() async {
    final reg =
        await widget.databasePort.getPendingRegistration(widget.fullname);
    if (reg != null && mounted) {
      setState(() {
        _nameNewTxid = reg.nameNewTxid;
        _saltHex = reg.saltHex;
        _dbChecked = true;
      });
    } else if (mounted) {
      setState(() => _dbChecked = true);
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _saltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _valueController.text;
    final byteLength = utf8.encode(valueText).length;

    return Scaffold(
      appBar: AppBar(title: Text('Register ${widget.fullname}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionCardWidget(
              title: 'Name',
              child: Text(
                widget.fullname,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
            SectionCardWidget(
              title: 'Value (optional)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set the value for this name. '
                    'You can leave it empty and update it later.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'JSON value',
                      hintText: '{"ip":"1.2.3.4"}',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 4),
                  ByteCounterWidget(current: byteLength),
                  if (byteLength > 520)
                    Text(
                      'Value exceeds 520 byte limit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step 1: name_new (skip if pending found in DB)
            if (_dbChecked && _nameNewTxid == null && _saltHex == null)
              ElevatedButton(
                onPressed: _loading || byteLength > 520 ? null : _nameNew,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Step 1: Register (name_new)'),
              ),

            if (!_dbChecked)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),

            if (_nameNewTxid != null)
              SectionCardWidget(
                title: 'Step 1: name_new',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 6),
                        Text('Broadcast successful'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CopyableFieldWidget(label: 'txid', value: _nameNewTxid!),
                    if (_saltHex != null)
                      CopyableFieldWidget(
                        label: 'Salt (saved in database)',
                        value: _saltHex!,
                      ),
                  ],
                ),
              ),

            // Manual salt fallback (for pre-DB registrations)
            if (_dbChecked && _nameNewTxid == null && _saltHex == null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    setState(() => _showManualSalt = !_showManualSalt),
                child: Text(_showManualSalt
                    ? 'Hide manual salt input'
                    : 'Have a salt from a previous session?'),
              ),
              if (_showManualSalt)
                SectionCardWidget(
                  title: 'Manual resume',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _saltController,
                        decoration: const InputDecoration(
                          labelText: 'Salt (hex)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _saltController.text.trim().isNotEmpty
                            ? () => setState(() {
                                  _saltHex = _saltController.text.trim();
                                })
                            : null,
                        child: const Text('Resume with this salt'),
                      ),
                    ],
                  ),
                ),
            ],

            // Step 2: name_firstupdate
            if (_saltHex != null && _firstUpdateTxid == null) ...[
              const SizedBox(height: 8),
              SectionCardWidget(
                title: 'Step 2: Finalize (name_firstupdate)',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CopyableFieldWidget(label: 'Salt', value: _saltHex!),
                    const SizedBox(height: 8),
                    const Text(
                      'Wait at least 12 blocks (~2 hours) after name_new '
                      'is mined, then tap Finalize.',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed:
                          _loading || byteLength > 520 ? null : _firstUpdate,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Finalize (name_firstupdate)'),
                    ),
                  ],
                ),
              ),
            ],

            if (_firstUpdateTxid != null)
              SectionCardWidget(
                title: 'Registration complete!',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 6),
                        Text('Name registered successfully'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CopyableFieldWidget(
                        label: 'txid', value: _firstUpdateTxid!),
                  ],
                ),
              ),

            if (_error != null) ErrorCardWidget(message: _error!),
          ],
        ),
      ),
    );
  }

  Future<void> _nameNew() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result =
          await widget.registerNameUseCase.nameNew(widget.fullname);
      setState(() {
        _nameNewTxid = result.txid;
        _saltHex = result.saltHex;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _firstUpdate() async {
    if (_saltHex == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final value = _valueController.text.trim();
      final txid = await widget.registerNameUseCase.nameFirstUpdate(
        widget.fullname,
        value.isEmpty ? '{}' : value,
        _saltHex!,
      );
      setState(() {
        _firstUpdateTxid = txid;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }
}

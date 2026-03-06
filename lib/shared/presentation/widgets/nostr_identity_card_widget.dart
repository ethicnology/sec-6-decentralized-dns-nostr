import 'package:flutter/material.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/copyable_field_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/relay_list_widget.dart';

class NostrIdentityCardWidget extends StatelessWidget {
  final String address;
  final String pubkeyHex;
  final String? npub;
  final List<String> relays;
  final VoidCallback? onChat;

  const NostrIdentityCardWidget({
    super.key,
    required this.address,
    required this.pubkeyHex,
    this.npub,
    this.relays = const [],
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onChat != null)
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  onPressed: onChat,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Chat',
                ),
            ],
          ),
          if (npub != null)
            CopyableFieldWidget(label: 'npub', value: npub!),
          CopyableFieldWidget(label: 'hex', value: pubkeyHex),
          if (relays.isNotEmpty) ...[
            const SizedBox(height: 4),
            RelayListWidget(relays: relays),
          ],
        ],
      ),
    );
  }
}

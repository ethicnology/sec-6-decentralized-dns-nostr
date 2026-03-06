import 'package:flutter/material.dart';
import 'package:nostr_namecoin/shared/domain/entities/namecoin_value_entity.dart';
import 'package:nostr_namecoin/features/resolve/domain/entities/resolve_result_entity.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';

class NameResultCardWidget extends StatelessWidget {
  final ResolveResultEntity result;
  final String Function(String hexPubkey)? hexToNpub;
  final void Function(String pubkeyHex, List<String> relays, String contactName)? onChat;
  final VoidCallback? onRegister;
  final VoidCallback? onTap;

  const NameResultCardWidget({
    super.key,
    required this.result,
    this.hexToNpub,
    this.onChat,
    this.onRegister,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final value = result.value;
    final colorScheme = Theme.of(context).colorScheme;

    final String statusLabel;
    final Color statusColor;
    if (!result.exists) {
      statusLabel = 'Available';
      statusColor = Colors.green;
    } else if (result.isExpired) {
      statusLabel = 'Expired';
      statusColor = colorScheme.error;
    } else {
      statusLabel = 'Active';
      statusColor = colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: SectionCardWidget(
        title: result.fullname,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status row
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!result.isAvailable &&
                    result.blocksUntilExpiry != null) ...[
                  const Spacer(),
                  Text(
                    '${result.blocksUntilExpiry} blocks left',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Available → Register
            if (result.isAvailable) ...[
              Text(
                result.exists
                    ? 'Expired — available for re-registration'
                    : 'Not registered — available',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (onRegister != null) ...[
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: onRegister,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Register'),
                ),
              ],
            ],

            // Active name → show Nostr identities only (tap for full details)
            if (result.exists && !result.isExpired && value != null) ...[
              if (value.hasNostr) ...[
                const SizedBox(height: 6),
                for (final entry in value.nostrNames.entries) ...[
                  _nostrEntry(context, entry.key, entry.value, value),
                ],
              ],
              if (onTap != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Tap for details',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(100),
                      ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _nostrEntry(
    BuildContext context,
    String nameKey,
    String pubkeyHex,
    NamecoinValueEntity value,
  ) {
    final address =
        NamecoinValueEntity.formatNostrAddress(result.fullname, nameKey);
    final npub = hexToNpub?.call(pubkeyHex);
    final relays = value.nostrRelays[pubkeyHex] ?? [];
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, size: 14, color: colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onChat != null)
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  onPressed: () => onChat!(pubkeyHex, relays, address),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          if (npub != null)
            Text(
              npub,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

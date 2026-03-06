import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/section_card_widget.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/conversation_list_item_widget.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/chat/presentation/pages/chat_page.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';

class NostrPage extends StatefulWidget {
  final NostrFacade nostrFacade;
  final NostrRelayPort nostrRelayPort;
  final VoidCallback onNavigateToSettings;

  const NostrPage({
    super.key,
    required this.nostrFacade,
    required this.nostrRelayPort,
    required this.onNavigateToSettings,
  });

  @override
  State<NostrPage> createState() => _NostrPageState();
}

class _NostrPageState extends State<NostrPage> {
  final _nostrKeyPort = NostrKeyAdapter(NostrFacade());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityBloc, IdentityState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is! IdentityLoadedState)
                SectionCardWidget(
                  title: 'Nostr',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Set up your Nostr identity and relay in Settings to start messaging.',
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: widget.onNavigateToSettings,
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text('Go to Settings'),
                      ),
                    ],
                  ),
                ),
              if (state is IdentityLoadedState) ...[
                SectionCardWidget(
                  title: 'Conversations',
                  child: _buildConversationList(state),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildConversationList(IdentityLoadedState state) {
    if (state.messages.isEmpty) {
      return Column(
        children: [
          Text(
            state.relayConnected
                ? 'Listening for messages...'
                : 'Connect to a relay in Settings to receive messages',
          ),
          const SizedBox(height: 8),
          Text(
            'Search for a Namecoin name and tap Chat on a Nostr key to start a conversation.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    final conversations = <String, List<DirectMessageEntity>>{};
    for (final msg in state.messages) {
      final contactKey =
          msg.isOutgoing ? msg.recipientPubkeyHex : msg.senderPubkeyHex;
      conversations.putIfAbsent(contactKey, () => []).add(msg);
    }

    final sorted = conversations.entries.toList()
      ..sort((a, b) =>
          b.value.last.timestamp.compareTo(a.value.last.timestamp));

    return Column(
      children: sorted.map((entry) {
        final contactPubkey = entry.key;
        final msgs = entry.value;
        final lastMsg = msgs.last;
        final contactName = state.contactNames[contactPubkey];
        final displayName = contactName ??
            (() {
              final npub = _nostrKeyPort.hexToNpub(contactPubkey);
              return '${npub.substring(0, 12)}...${npub.substring(npub.length - 8)}';
            })();

        return ConversationListItemWidget(
          name: displayName,
          lastMessage: lastMsg.content,
          lastTimestamp: lastMsg.timestamp,
          onTap: () => _openChat(contactPubkey, contactName),
        );
      }).toList(),
    );
  }

  void _openChat(String recipientPubkeyHex, String? contactName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<IdentityBloc>(),
          child: ChatPage(
            recipientPubkeyHex: recipientPubkeyHex,
            nostrFacade: widget.nostrFacade,
            nostrRelayPort: widget.nostrRelayPort,
            contactName: contactName,
          ),
        ),
      ),
    );
  }
}

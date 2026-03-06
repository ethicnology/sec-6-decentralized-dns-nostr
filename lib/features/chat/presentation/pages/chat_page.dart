import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/shared/presentation/widgets/message_bubble_widget.dart';
import 'package:nostr_namecoin/features/chat/domain/entities/direct_message_entity.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_bloc.dart';
import 'package:nostr_namecoin/features/identity/presentation/bloc/identity_state.dart';

class ChatPage extends StatefulWidget {
  final String recipientPubkeyHex;
  final NostrFacade nostrFacade;
  final NostrRelayPort nostrRelayPort;
  final String? contactName;

  const ChatPage({
    super.key,
    required this.recipientPubkeyHex,
    required this.nostrFacade,
    required this.nostrRelayPort,
    this.contactName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<DirectMessageEntity> _filterMessages(IdentityLoadedState state) {
    return state.messages
        .where((m) =>
            m.senderPubkeyHex == widget.recipientPubkeyHex ||
            m.recipientPubkeyHex == widget.recipientPubkeyHex)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    final npub = NostrKeyAdapter(NostrFacade())
        .hexToNpub(widget.recipientPubkeyHex);
    final shortNpub =
        '${npub.substring(0, 12)}...${npub.substring(npub.length - 8)}';

    return Scaffold(
      appBar: AppBar(
        title: widget.contactName != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.contactName!,
                      style: const TextStyle(fontSize: 16)),
                  Text(shortNpub,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153))),
                ],
              )
            : Text(shortNpub,
                style:
                    const TextStyle(fontFamily: 'monospace', fontSize: 14)),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<IdentityBloc, IdentityState>(
              builder: (context, state) {
                if (state is! IdentityLoadedState) {
                  return const Center(child: Text('Identity not loaded'));
                }
                final messages = _filterMessages(state);
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return MessageBubbleWidget(
                      content: msg.content,
                      isOutgoing: msg.isOutgoing,
                      timestamp: msg.timestamp,
                    );
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Message...',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sending ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final identityBloc = context.read<IdentityBloc>();
    final identityState = identityBloc.state;
    if (identityState is! IdentityLoadedState) return;

    setState(() => _sending = true);
    _messageController.clear();

    try {
      final giftWrap = await widget.nostrFacade.encodeDirectMessage(
        message: text,
        senderPrivkeyHex: identityState.keypair.privateKeyHex,
        recipientPubkeyHex: widget.recipientPubkeyHex,
      );
      await widget.nostrRelayPort.publish(giftWrap);

      final outgoing = DirectMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        senderPubkeyHex: identityState.keypair.publicKeyHex,
        recipientPubkeyHex: widget.recipientPubkeyHex,
        content: text,
        timestamp: DateTime.now(),
        isOutgoing: true,
      );
      identityBloc.addOutgoingMessage(outgoing);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}

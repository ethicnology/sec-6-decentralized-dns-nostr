import 'package:flutter/material.dart';

class ConversationListItemWidget extends StatelessWidget {
  final String name;
  final String? lastMessage;
  final DateTime? lastTimestamp;
  final VoidCallback? onTap;

  const ConversationListItemWidget({
    super.key,
    required this.name,
    this.lastMessage,
    this.lastTimestamp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: lastMessage != null
          ? Text(
              lastMessage!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: lastTimestamp != null
          ? Text(
              '${lastTimestamp!.hour.toString().padLeft(2, '0')}:'
              '${lastTimestamp!.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.labelSmall,
            )
          : null,
      onTap: onTap,
    );
  }
}

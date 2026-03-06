import 'package:flutter/material.dart';

class RelayListWidget extends StatelessWidget {
  final List<String> relays;
  final ValueChanged<String>? onRemove;

  const RelayListWidget({super.key, required this.relays, this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (relays.isEmpty) {
      return Text('No relays', style: Theme.of(context).textTheme.bodySmall);
    }
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: relays.map((relay) {
        return Chip(
          label: Text(relay, style: const TextStyle(fontSize: 12)),
          deleteIcon: onRemove != null ? const Icon(Icons.close, size: 16) : null,
          onDeleted: onRemove != null ? () => onRemove!(relay) : null,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}

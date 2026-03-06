import 'package:flutter/material.dart';

class DnsRecordFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const DnsRecordFieldWidget({
    super.key,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

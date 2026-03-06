import 'package:flutter/material.dart';

class ByteCounterWidget extends StatelessWidget {
  final int current;
  final int max;

  const ByteCounterWidget({
    super.key,
    required this.current,
    this.max = 520,
  });

  @override
  Widget build(BuildContext context) {
    final isOver = current > max;
    return Text(
      '$current / $max bytes',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isOver ? Theme.of(context).colorScheme.error : null,
            fontWeight: isOver ? FontWeight.bold : null,
          ),
    );
  }
}

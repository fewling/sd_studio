import 'package:flutter/material.dart';

class SliderTile extends StatelessWidget {
  const SliderTile({
    required this.title,
    required this.tooltip,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.divisions,
    super.key,
  });

  final String title;
  final String tooltip;
  final String label;
  final double min;
  final double max;
  final int? divisions;
  final double value;
  final Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title),
            const SizedBox(width: 16),
            Tooltip(
              message: tooltip,
              child: const Icon(size: 16, Icons.tips_and_updates_outlined),
            ),
          ],
        ),
        Slider(
          label: label,
          min: min,
          max: max,
          divisions: divisions,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

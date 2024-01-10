import 'package:flutter/material.dart';

class WeightedPromptTile extends StatelessWidget {
  const WeightedPromptTile({
    required this.title,
    required this.subtitle,
    this.onAdd,
    this.onMinus,
    this.onDelete,
    this.tileColor,
    this.textColor,
    super.key,
  });

  final String title;
  final String subtitle;

  final VoidCallback? onAdd;
  final VoidCallback? onMinus;
  final VoidCallback? onDelete;

  final Color? tileColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textColor: textColor,
      tileColor: tileColor,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: onAdd,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add_circle_outline),
            ),
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: onMinus,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.remove_circle_outline),
            ),
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: onDelete,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }
}

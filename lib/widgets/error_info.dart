import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    required this.e,
    required this.s,
    super.key,
  });

  final Object e;
  final StackTrace s;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final txtTheme = Theme.of(context).textTheme;

    return kDebugMode
        ? Column(
            children: [
              Text(e.toString()),
              const Divider(),
              Card(child: Text(s.toString())),
            ],
          )
        : IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: colorScheme.errorContainer,
                iconColor: colorScheme.onErrorContainer,
                titleTextStyle: txtTheme.titleLarge
                    ?.copyWith(color: colorScheme.onErrorContainer),
                contentTextStyle: txtTheme.bodyLarge
                    ?.copyWith(color: colorScheme.onErrorContainer),
                icon: Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                ),
                title: const Text('Error'),
                content: SelectionArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.toString()),
                      const Divider(),
                      Text(s.toString()),
                    ],
                  ),
                ),
              ),
            ),
            icon: Icon(
              Icons.error_outline,
              color: colorScheme.error,
            ),
          );
  }
}

import 'package:flutter/material.dart';

import '../models/sd/weighted_prompt.dart';
import 'weighted_prompt_tile.dart';

class PromptWeightDrawer extends StatelessWidget {
  const PromptWeightDrawer({
    required this.prompt,
    required this.negativePrompt,
    super.key,
    this.onPromptIncrease,
    this.onPromptDecrease,
    this.onPromptDelete,
    this.onNegativePromptIncrease,
    this.onNegativePromptDecrease,
    this.onNegativePromptDelete,
  });

  final String prompt;
  final String negativePrompt;

  final void Function(String prompt)? onPromptIncrease;
  final void Function(String prompt)? onPromptDecrease;
  final void Function(String prompt)? onPromptDelete;

  final void Function(String prompt)? onNegativePromptIncrease;
  final void Function(String prompt)? onNegativePromptDecrease;
  final void Function(String prompt)? onNegativePromptDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final splicedPrompt = prompt.split(',');
    final splicedNegativePrompt = negativePrompt.split(',');

    final weightedPrompts = prompt.isEmpty
        ? <WeightedPrompt>[]
        : splicedPrompt.map((e) {
            if (!e.contains(':')) {
              return WeightedPrompt(prompt: e, weight: 1);
            }

            final parts = e.split(':');
            return WeightedPrompt(
              prompt: parts[0].replaceFirst('(', ''),
              weight: double.tryParse(parts[1].replaceFirst(')', '')) ?? 1,
            );
          }).toList();

    final weightedNegativePrompts = negativePrompt.isEmpty
        ? <WeightedPrompt>[]
        : splicedNegativePrompt.map((e) {
            if (!e.contains(':')) {
              return WeightedPrompt(prompt: e, weight: 1);
            }

            final parts = e.split(':');
            return WeightedPrompt(
              prompt: parts[0].replaceFirst('(', ''),
              weight: double.tryParse(parts[1].replaceFirst(')', '')) ?? 1,
            );
          }).toList();

    return Drawer(
      child: ListView.builder(
        itemCount: weightedPrompts.length + weightedNegativePrompts.length,
        itemBuilder: (context, index) {
          if (index < weightedPrompts.length && weightedPrompts.isNotEmpty) {
            final prompt = weightedPrompts[index].prompt;
            final weight = weightedPrompts[index].weight;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: WeightedPromptTile(
                title: prompt.trim(),
                subtitle: weight.toString(),
                onAdd: () => onPromptIncrease?.call(prompt),
                onMinus: () => onPromptDecrease?.call(prompt),
                onDelete: () => onPromptDelete?.call(prompt),
                textColor: colorScheme.onSecondaryContainer,
                tileColor: colorScheme.secondaryContainer.withOpacity(0.7),
              ),
            );
          }

          final idx = index - weightedPrompts.length;
          final negPrompt = weightedNegativePrompts[idx].prompt;
          final negWeight = weightedNegativePrompts[idx].weight;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: WeightedPromptTile(
              title: negPrompt.trim(),
              subtitle: negWeight.toString(),
              onAdd: () => onNegativePromptIncrease?.call(negPrompt),
              onMinus: () => onNegativePromptDecrease?.call(negPrompt),
              onDelete: () => onNegativePromptDelete?.call(negPrompt),
              textColor: colorScheme.onError,
              tileColor: colorScheme.error.withOpacity(0.7),
            ),
          );
        },
      ),
    );
  }
}

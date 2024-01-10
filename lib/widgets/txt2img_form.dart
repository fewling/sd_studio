import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/global_controller_providers.dart';
import 'slider_tile.dart';

typedef DoubleCallback = void Function(double value);

class Txt2ImgForm extends StatelessWidget {
  const Txt2ImgForm({
    required this.cfgScale,
    required this.onCfgScaleChanged,
    required this.steps,
    required this.onStepsChanged,
    required this.batchSize,
    required this.onBatchSizeChanged,
    required this.width,
    required this.onWidthChanged,
    required this.height,
    required this.onHeightChanged,
    this.prompt,
    this.onSortPrompt,
    this.negativePrompt,
    this.onSortNegativePrompt,
    super.key,
  });

  final String? prompt;
  final VoidCallback? onSortPrompt;

  final String? negativePrompt;
  final VoidCallback? onSortNegativePrompt;

  final int cfgScale;
  final DoubleCallback onCfgScaleChanged;

  final int steps;
  final DoubleCallback onStepsChanged;

  final int batchSize;
  final DoubleCallback onBatchSizeChanged;

  final int width;
  final DoubleCallback onWidthChanged;

  final int height;
  final DoubleCallback onHeightChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Positive Prompt
        Consumer(
          builder: (context, ref, child) => TextFormField(
            controller: ref.watch(promptControllerProvider),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your prompt here',
              border: const OutlineInputBorder(),
              filled: true,
              labelText: 'Prompt',
              suffixIcon: IconButton(
                onPressed: onSortPrompt,
                icon: const Icon(Icons.sort),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Negative Prompt
        Consumer(
          builder: (context, ref, child) => TextFormField(
            controller: ref.watch(negPromptControllerProvider),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your negative prompt here',
              border: const OutlineInputBorder(),
              filled: true,
              labelText: 'Negative Prompt',
              suffixIcon: IconButton(
                onPressed: onSortNegativePrompt,
                icon: const Icon(Icons.sort),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Guidance Scale Slider
        SliderTile(
          title: 'Guidance Scale: $cfgScale',
          tooltip: 'How much the model should focus on the prompt.',
          label: cfgScale.toString(),
          min: 1,
          max: 20,
          divisions: 19,
          value: cfgScale.toDouble(),
          onChanged: onCfgScaleChanged,
        ),

        // Num of Inference Steps Slider
        SliderTile(
          title: 'Inference Steps: $steps',
          tooltip: 'Steps to take to generate image '
              '(more is better generally, with diminishing returns after 50).',
          label: steps.toString(),
          min: 1,
          // max: 500,
          // divisions: 499,
          max: 100,
          divisions: 99,
          value: steps.toDouble(),
          onChanged: onStepsChanged,
        ),

        // Batch Size Slider
        SliderTile(
          title: 'No. of Images: $batchSize',
          tooltip: 'Number of images to generate.',
          label: batchSize.toString(),
          min: 1,
          max: 10,
          divisions: 9,
          value: batchSize.toDouble(),
          onChanged: onBatchSizeChanged,
        ),

        const SizedBox(height: 8),

        // Width Slider
        SliderTile(
          title: 'Width: $width',
          tooltip: 'Width of the generated image.',
          min: 128,
          max: 1024,
          label: width.toString(),
          value: width.toDouble(),
          onChanged: onWidthChanged,
          divisions: (1024 - 128) ~/ 8,
        ),

        const SizedBox(height: 8),

        // Height Slider
        SliderTile(
          title: 'Height: $height',
          tooltip: 'Height of the generated image.',
          min: 128,
          max: 1024,
          label: height.toString(),
          value: height.toDouble(),
          onChanged: onHeightChanged,
          divisions: (1024 - 128) ~/ 8,
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

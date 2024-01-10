import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_controller_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldState> baseScaffoldKey(BaseScaffoldKeyRef ref) =>
    GlobalKey<ScaffoldState>();

@Riverpod(keepAlive: true)
// ignore: unsupported_provider_value
TextEditingController promptController(PromptControllerRef ref) {
  final controller = TextEditingController();

  controller.addListener(() {
    ref.read(_promptStreamControllerProvider).add(controller.text);
  });

  controller.text = 'Astronaut riding horse on moon';

  return controller;
}

@riverpod
StreamController<String> _promptStreamController(
    _PromptStreamControllerRef ref) {
  return StreamController<String>();
}

@riverpod
Stream<String> promptStream(PromptStreamRef ref) {
  return ref.watch(_promptStreamControllerProvider).stream;
}

@Riverpod(keepAlive: true)
// ignore: unsupported_provider_value
TextEditingController negPromptController(NegPromptControllerRef ref) {
  final controller = TextEditingController();

  controller.addListener(() {
    ref.read(_negPromptStreamControllerProvider).add(controller.text);
  });

  controller.text = 'ugly, tiling, poorly drawn hands, poorly drawn feet, '
      'poorly drawn face, out of frame, extra limbs, disfigured, '
      'deformed, body out of frame, bad anatomy, watermark, signature, '
      'cut off, low contrast, underexposed, overexposed, bad art, '
      'beginner, amateur, distorted face';

  return controller;
}

@riverpod
StreamController<String> _negPromptStreamController(
    _NegPromptStreamControllerRef ref) {
  return StreamController<String>();
}

@riverpod
Stream<String> negPromptStream(NegPromptStreamRef ref) {
  return ref.watch(_negPromptStreamControllerProvider).stream;
}

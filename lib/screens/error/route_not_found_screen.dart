import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../service/app_router.dart';

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page Not Found'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  void _pop(BuildContext context) {
    context.canPop() ? context.pop() : context.goNamed(Location.txt2img.name);
  }
}

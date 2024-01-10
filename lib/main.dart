import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service/app_router.dart';
import 'service/preference_provider.dart';
import 'utils/riverpod_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  final sp = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefProvider.overrideWith((_) => sp)],
      observers: [RiverpodObserver()],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appPreference = ref.watch(appPreferenceControllerProvider);
    final colorSeed = appPreference.colorSchemeSeed;
    final isDarkMode = appPreference.isDarkMode;

    return OKToast(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          colorSchemeSeed: Color(colorSeed),
        ),
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}

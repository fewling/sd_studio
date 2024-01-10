import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';

class RiverpodObserver extends ProviderObserver {
  @override
  void didUpdateProvider(provider, previousValue, newValue, container) {
    if (provider.name == 'shopCountdownProvider') return;
    if (provider.name == 'enemiesProvider') return;
    if (provider.name == 'merchandiseProvider') return;
    if (provider is FutureProvider) return;

    // logger.t('UPDATED: provider: ${provider.name ?? provider.runtimeType}, '
    //     'newValue: $newValue');
  }

  @override
  void didAddProvider(provider, value, container) {
    super.didAddProvider(provider, value, container);

    logger.d('ADDED: provider: ${provider.name ?? provider.runtimeType}, '
        'value: $value');
  }

  @override
  void didDisposeProvider(provider, container) {
    super.didDisposeProvider(provider, container);
    logger.w('DISPOSED: provider: ${provider.name ?? provider.runtimeType}');
  }
}

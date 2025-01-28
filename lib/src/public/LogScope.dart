/// The possible scope of logs to print to the console.
enum LogScope {
  localizationManager,
  bounceButton,
  coreData,
  configManager,
  identityManager,
  debugManager,
  debugViewController,
  localizationViewController,
  gameControllerManager,
  device,
  network,
  paywallEvents,
  productsManager,
  storeKitManager,
  placements,
  receipts,
  superwallCore,
  paywallPresentation,
  transactions,
  paywallViewController,
  cache,
  all
}

extension LogScopeJson on LogScope {
  String toJson() {
    switch (this) {
      case LogScope.localizationManager:
        return 'localizationManager';
      case LogScope.bounceButton:
        return 'bounceButton';
      case LogScope.coreData:
        return 'coreData';
      case LogScope.configManager:
        return 'configManager';
      case LogScope.identityManager:
        return 'identityManager';
      case LogScope.debugManager:
        return 'debugManager';
      case LogScope.debugViewController:
        return 'debugViewController';
      case LogScope.localizationViewController:
        return 'localizationViewController';
      case LogScope.gameControllerManager:
        return 'gameControllerManager';
      case LogScope.device:
        return 'device';
      case LogScope.network:
        return 'network';
      case LogScope.paywallEvents:
        return 'paywallEvents';
      case LogScope.productsManager:
        return 'productsManager';
      case LogScope.storeKitManager:
        return 'storeKitManager';
      case LogScope.placements:
        return 'placements';
      case LogScope.receipts:
        return 'receipts';
      case LogScope.superwallCore:
        return 'superwallCore';
      case LogScope.paywallPresentation:
        return 'paywallPresentation';
      case LogScope.transactions:
        return 'transactions';
      case LogScope.paywallViewController:
        return 'paywallViewController';
      case LogScope.cache:
        return 'cache';
      case LogScope.all:
        return 'all';
    }
  }
}

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

  /// iOS only.
  analytics,

  /// iOS only.
  webEntitlements,

  /// iOS only.
  grantedEntitlements,

  /// iOS only.
  customerCenter,

  /// Android only.
  customerInfo,

  /// Android only.
  jsEvaluator,

  /// Android only.
  paywallTransactions,

  /// Android only.
  nativePurchaseController,

  /// Android only.
  deepLinks,
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
      case LogScope.analytics:
        return 'analytics';
      case LogScope.webEntitlements:
        return 'webEntitlements';
      case LogScope.grantedEntitlements:
        return 'grantedEntitlements';
      case LogScope.customerCenter:
        return 'customerCenter';
      case LogScope.customerInfo:
        return 'customerInfo';
      case LogScope.jsEvaluator:
        return 'jsEvaluator';
      case LogScope.paywallTransactions:
        return 'paywallTransactions';
      case LogScope.nativePurchaseController:
        return 'nativePurchaseController';
      case LogScope.deepLinks:
        return 'deepLinks';
      case LogScope.all:
        return 'all';
    }
  }
}

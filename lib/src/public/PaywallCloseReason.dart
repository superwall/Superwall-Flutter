/// An enum whose cases indicate whether the paywall was closed by user
/// interaction or because another paywall will show.
enum PaywallCloseReason {
  systemLogic,
  forNextPaywall,
  webViewFailedToLoad,
  manualClose,
  none,
}

import Flutter
import SuperwallKit
import UIKit

/// Creates the platform views behind Flutter's embedded `PaywallView`.
final class PaywallPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
  static let viewType = "superwallkit_flutter/paywall_view"

  private let binaryMessenger: FlutterBinaryMessenger

  init(binaryMessenger: FlutterBinaryMessenger) {
    self.binaryMessenger = binaryMessenger
    super.init()
  }

  // Flutter creates platform views on the main thread.
  @MainActor
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let arguments = args as? [String: Any] ?? [:]
    let hostId = arguments["hostId"] as? String ?? ""
    let params = (arguments["params"] as? [String: Any]).map { PaywallPlatformView.removingNulls(from: $0) }

    return PaywallPlatformView(
      frame: frame,
      flutterCallback: PPaywallViewCallbackGenerated(
        binaryMessenger: binaryMessenger,
        messageChannelSuffix: hostId
      ),
      placement: arguments["placement"] as? String ?? "",
      params: params
    )
  }

  // Without this, Flutter doesn't decode the creation params and `arguments` is nil.
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

@MainActor
final class PaywallPlatformView: NSObject, FlutterPlatformView {
  private let hostView: PaywallHostView

  init(
    frame: CGRect,
    flutterCallback: PPaywallViewCallbackGenerated,
    placement: String,
    params: [String: Any]?
  ) {
    hostView = PaywallHostView(
      frame: frame,
      flutterCallback: flutterCallback,
      placement: placement,
      params: params
    )
    super.init()
  }

  func view() -> UIView {
    return hostView
  }

  /// Dart's `null` arrives as `NSNull`, which the SDK can't use as a param value.
  nonisolated static func removingNulls(from dictionary: [String: Any]) -> [String: Any] {
    return dictionary.compactMapValues { removingNulls(fromValue: $0) }
  }

  // Not an overload of `removingNulls(from:)`. As one, Swift prefers it for a
  // nested dictionary too, because its `Any?` result needs no conversion, and it
  // calls itself forever.
  nonisolated private static func removingNulls(fromValue value: Any) -> Any? {
    switch value {
    case is NSNull:
      return nil
    case let dictionary as [String: Any]:
      return removingNulls(from: dictionary)
    case let array as [Any]:
      return array.compactMap { removingNulls(fromValue: $0) }
    default:
      return value
    }
  }
}

/// Hosts a paywall retrieved through Superwall's `getPaywall` API.
///
/// Each host has one placement and one set of params for its whole life: Flutter
/// makes a new platform view when either changes. The host owns at most one
/// PaywallViewController and discards it when it leaves the window; native paywall
/// controllers must never be reused in another view hierarchy.
final class PaywallHostView: UIView, PaywallViewControllerDelegate {
  private let flutterCallback: PPaywallViewCallbackGenerated
  private let placement: String
  private let params: [String: Any]?

  /// Whether a load has started, or settled, since the host last joined a window.
  private var hasLoaded = false
  /// Set once the paywall finished with `shouldDismiss`. Flutter is told to remove
  /// the view then, so the paywall isn't loaded again if the view is reattached first.
  private var isFinished = false
  private var loadGeneration = 0
  private var loadTask: Task<Void, Never>?
  private var paywallViewController: PaywallViewController?

  init(
    frame: CGRect,
    flutterCallback: PPaywallViewCallbackGenerated,
    placement: String,
    params: [String: Any]?
  ) {
    self.flutterCallback = flutterCallback
    self.placement = placement
    self.params = params
    super.init(frame: frame)
    clipsToBounds = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Flutter can take a platform view out of the window and put it back. The
  // paywall is let go when that happens, and loaded again on return.
  override func didMoveToWindow() {
    super.didMoveToWindow()

    if window == nil {
      invalidateAndDetach()
    } else {
      loadPaywallIfNeeded()
    }
  }

  private func loadPaywallIfNeeded() {
    guard window != nil, !isFinished else {
      return
    }

    guard !hasLoaded else {
      attachPaywallViewControllerIfNeeded()
      return
    }

    guard !placement.isEmpty else {
      reportError("PaywallView needs a placement.")
      return
    }

    // `Superwall.shared` asserts when the SDK isn't configured.
    guard Superwall.isInitialized else {
      reportError("Superwall must be configured before a PaywallView is shown.")
      return
    }

    hasLoaded = true
    loadGeneration += 1
    let generation = loadGeneration
    loadTask?.cancel()
    detachPaywallViewController()
    flutterCallback.onLoadStart { _ in }

    let placement = self.placement
    let params = self.params

    loadTask = Task { @MainActor [weak self] in
      guard let self = self else { return }

      do {
        let paywall = try await Superwall.shared.getPaywall(
          forPlacement: placement,
          params: params,
          delegate: self,
          onCustomCallback: { [weak self] callback in
            return await self?.handleCustomCallback(callback)
              ?? CustomCallbackResult(status: .failure, data: nil)
          }
        )

        guard !Task.isCancelled,
          generation == self.loadGeneration,
          self.window != nil
        else {
          return
        }

        guard paywall.parent == nil,
          paywall.presentingViewController == nil,
          paywall.viewIfLoaded?.superview == nil
        else {
          // Allow a reattach to retry once the other host lets go.
          self.hasLoaded = false
          self.reportError(
            "The retrieved paywall is already attached to another view. "
              + "Use a different placement for each mounted PaywallView."
          )
          return
        }

        self.paywallViewController = paywall
        guard self.attachPaywallViewControllerIfNeeded() else {
          self.paywallViewController = nil
          self.hasLoaded = false
          self.reportError("PaywallView couldn't find a view controller to show the paywall in.")
          return
        }
        self.flutterCallback.onPresent(paywallInfo: paywall.info.pigeonify()) { _ in }
      } catch let reason as PaywallSkippedReason {
        guard !Task.isCancelled, generation == self.loadGeneration else { return }
        self.flutterCallback.onSkip(
          reason: reason.pigeonify(),
          experiment: reason.pigeonExperiment
        ) { _ in }
      } catch is CancellationError {
        // Leaving the window invalidated this request.
      } catch {
        guard !Task.isCancelled, generation == self.loadGeneration else { return }
        // A failed load is not a settled decision (unlike a skip): let the same
        // host retry on the next reattach.
        self.hasLoaded = false
        self.reportError(error.localizedDescription)
      }
    }
  }

  private func handleCustomCallback(_ callback: CustomCallback) async -> CustomCallbackResult {
    return await callback.forwardToFlutter { pCallback, completion in
      flutterCallback.onCustomCallback(callback: pCallback, completion: completion)
    }
  }

  private func reportError(_ message: String) {
    flutterCallback.onError(error: message) { _ in }
  }

  // MARK: - PaywallViewControllerDelegate

  func paywall(
    _ paywall: PaywallViewController,
    didFinishWith result: PaywallResult,
    shouldDismiss: Bool
  ) {
    // A paywall this host has let go of may still report to it.
    guard paywall === paywallViewController else {
      return
    }

    if shouldDismiss {
      isFinished = true
      detachPaywallViewController()
    }

    flutterCallback.onFinished(
      paywallInfo: paywall.info.pigeonify(),
      result: result.pigeonify(),
      shouldDismiss: shouldDismiss
    ) { _ in }
  }

  func paywall(
    _ paywall: PaywallViewController,
    loadingStateDidChange loadingState: PaywallLoadingState
  ) {
    // Not limited to the attached paywall: the state can change while the
    // paywall is still being retrieved.
    guard window != nil else {
      return
    }

    let pState: PPaywallLoadingState
    switch loadingState {
    case .unknown:
      pState = .unknown
    case .loadingPurchase:
      pState = .loadingPurchase
    case .loadingURL:
      pState = .loadingUrl
    case .manualLoading:
      pState = .manualLoading
    case .ready:
      pState = .ready
    @unknown default:
      pState = .unknown
    }

    flutterCallback.onLoadingStateChanged(state: pState) { _ in }
  }

  // MARK: - Containment

  /// The nearest view controller above the host, which is the `FlutterViewController`.
  private func parentViewController() -> UIViewController? {
    var responder = next
    while let current = responder {
      if let viewController = current as? UIViewController {
        return viewController
      }
      responder = current.next
    }
    return window?.rootViewController
  }

  /// Returns `false` when there's a paywall but no view controller to add it to.
  @discardableResult
  private func attachPaywallViewControllerIfNeeded() -> Bool {
    guard let paywallViewController = paywallViewController else {
      return true
    }
    guard paywallViewController.view.superview !== self else {
      return true
    }
    guard let parentViewController = parentViewController() else {
      return false
    }

    parentViewController.addChild(paywallViewController)

    let paywallView: UIView = paywallViewController.view
    paywallView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(paywallView)
    NSLayoutConstraint.activate([
      paywallView.topAnchor.constraint(equalTo: topAnchor),
      paywallView.bottomAnchor.constraint(equalTo: bottomAnchor),
      paywallView.leadingAnchor.constraint(equalTo: leadingAnchor),
      paywallView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    paywallViewController.didMove(toParent: parentViewController)
    return true
  }

  private func detachPaywallViewController() {
    if let paywallViewController = paywallViewController {
      paywallViewController.willMove(toParent: nil)
      paywallViewController.view.removeFromSuperview()
      paywallViewController.removeFromParent()
    }
    self.paywallViewController = nil
  }

  private func invalidateAndDetach() {
    loadGeneration += 1
    loadTask?.cancel()
    loadTask = nil
    hasLoaded = false
    detachPaywallViewController()
  }

  deinit {
    loadTask?.cancel()
  }
}

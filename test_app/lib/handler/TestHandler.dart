import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class TestHandler {
  final PaywallPresentationHandler handler;
  final List<HandlerEvent> events = [];

  TestHandler(this.handler) {
    handler.onDismissHandler = (info, result) {
      events.add(DismissEvent(info, result));
    };
    handler.onErrorHandler = (error) {
      events.add(ErrorEvent(error));
    };
    handler.onPresentHandler = (info) {
      events.add(PresentEvent(info));
    };
    handler.onSkipHandler = (reason) {
      events.add(SkipEvent(reason));
    };
  }
}

/// A sealed class representing events from PaywallPresentationHandler
sealed class HandlerEvent {}

/// Event triggered when a paywall is presented
class PresentEvent extends HandlerEvent {
  final PaywallInfo paywallInfo;

  PresentEvent(this.paywallInfo);
}

/// Event triggered when a paywall is dismissed
class DismissEvent extends HandlerEvent {
  final PaywallInfo paywallInfo;
  final PaywallResult result;

  DismissEvent(this.paywallInfo, this.result);
}

/// Event triggered when an error occurs
class ErrorEvent extends HandlerEvent {
  final String errorMessage;

  ErrorEvent(this.errorMessage);
}

/// Event triggered when a paywall is skipped
class SkipEvent extends HandlerEvent {
  final PaywallSkippedReason reason;

  SkipEvent(this.reason);
}

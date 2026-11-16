import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _callbackPrefix =
    'dev.flutter.pigeon.superwallkit_flutter.PPaywallViewCallbackGenerated';
const _codec = PPaywallViewCallbackGenerated.pigeonChannelCodec;

/// A platform view the fake platform was asked to create.
class _CreatedView {
  _CreatedView(this.id, this.viewType, this.params);

  final int id;
  final String viewType;
  final Map<Object?, Object?> params;

  String get hostId => params['hostId']! as String;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<_CreatedView> created;
  late List<int> disposed;

  /// Fakes the platform side of platform views, recording what is created
  /// and disposed.
  void fakePlatformViews() {
    created = [];
    disposed = [];
    messenger.setMockMethodCallHandler(SystemChannels.platform_views,
        (call) async {
      switch (call.method) {
        case 'create':
          final args = call.arguments as Map<Object?, Object?>;
          final params = args['params'] as Uint8List;
          created.add(_CreatedView(
            args['id']! as int,
            args['viewType']! as String,
            const StandardMessageCodec()
                    .decodeMessage(ByteData.sublistView(params))!
                as Map<Object?, Object?>,
          ));
          // Android replies with a texture ID, iOS with nothing.
          return defaultTargetPlatform == TargetPlatform.android ? 1 : null;
        case 'dispose':
          final args = call.arguments;
          disposed.add(args is Map ? args['id'] as int : args as int);
          return null;
        case 'resize':
          final args = call.arguments as Map<Object?, Object?>;
          return {'width': args['width'], 'height': args['height']};
        default:
          return null;
      }
    });
  }

  /// Sends a message from "native" to the callbacks registered under
  /// [hostId] and returns the decoded reply envelope, or `null` when nothing
  /// is registered.
  Future<List<Object?>?> callView(
      String hostId, String method, List<Object?> args) async {
    final replies = <List<Object?>?>[];
    await messenger.handlePlatformMessage(
      '$_callbackPrefix.$method.$hostId',
      _codec.encodeMessage(args),
      (reply) => replies.add(
          reply == null ? null : _codec.decodeMessage(reply) as List<Object?>?),
    );
    return replies.single;
  }

  Widget host(Widget child) => Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 300, height: 400, child: child)),
      );

  const loadingKey = Key('loading');
  Widget loading(BuildContext context) => const SizedBox(key: loadingKey);

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    fakePlatformViews();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(SystemChannels.platform_views, null);
  });

  testWidgets('iOS: creates the platform view with the creation params',
      (tester) async {
    await tester.pumpWidget(host(const PaywallView(
      placement: 'onboarding',
      params: {'source': 'test', 'count': 2},
    )));

    expect(find.byType(UiKitView), findsOneWidget);
    final view = created.single;
    expect(view.viewType, 'superwallkit_flutter/paywall_view');
    expect(view.hostId, isNotEmpty);
    expect(view.params['placement'], 'onboarding');
    expect(view.params['params'], {'source': 'test', 'count': 2});

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android: creates the platform view with the creation params',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.pumpWidget(host(const PaywallView(placement: 'onboarding')));

    expect(find.byType(AndroidView), findsOneWidget);
    final view = created.single;
    expect(view.viewType, 'superwallkit_flutter/paywall_view');
    expect(view.params['placement'], 'onboarding');
    expect(view.params.containsKey('params'), isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows the loading builder over the view until it is presented',
      (tester) async {
    final presented = <PaywallInfo>[];
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      loadingBuilder: loading,
      onPresent: presented.add,
    )));
    final hostId = created.single.hostId;

    expect(find.byKey(loadingKey), findsOneWidget);
    expect(find.byType(UiKitView), findsOneWidget);

    await callView(hostId, 'onLoadStart', []);
    await tester.pump();
    expect(find.byKey(loadingKey), findsOneWidget);

    await callView(hostId, 'onPresent', [PPaywallInfo(identifier: 'pw1')]);
    await tester.pump();
    expect(presented.single.identifier, 'pw1');
    expect(find.byKey(loadingKey), findsNothing);
    expect(find.byType(UiKitView), findsOneWidget);
    // The same platform view is kept.
    expect(created, hasLength(1));
    expect(disposed, isEmpty);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('onFinished reports the result and removes the view on dismiss',
      (tester) async {
    final finished = <String>[];
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      onFinished: (info, result, shouldDismiss) => finished
          .add('${info.identifier} ${result.runtimeType} $shouldDismiss'),
    )));
    final hostId = created.single.hostId;
    await callView(hostId, 'onPresent', [PPaywallInfo(identifier: 'pw1')]);

    await callView(hostId, 'onFinished', [
      PPaywallInfo(identifier: 'pw1'),
      PPurchasedPaywallResult(productId: 'monthly'),
      false,
    ]);
    await tester.pump();
    expect(find.byType(UiKitView), findsOneWidget);

    await callView(hostId, 'onFinished',
        [PPaywallInfo(identifier: 'pw1'), PDeclinedPaywallResult(), true]);
    await tester.pump();
    expect(find.byType(UiKitView), findsNothing);
    expect(finished, [
      'pw1 PurchasedPaywallResult false',
      'pw1 DeclinedPaywallResult true',
    ]);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows the skipped builder with the reason and its experiment',
      (tester) async {
    final skipped = <PaywallSkippedReason>[];
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      loadingBuilder: loading,
      onSkip: skipped.add,
      skippedBuilder: (context, reason) => Text(
          'skipped ${(reason as PaywallSkippedReasonHoldout).experiment!.id}'),
    )));

    await callView(created.single.hostId, 'onSkip', [
      PPaywallSkippedReason.holdout,
      PExperiment(
          id: 'exp1',
          groupId: 'group1',
          variant: PVariant(id: 'var1', type: PVariantType.holdout)),
    ]);
    await tester.pump();

    expect(find.text('skipped exp1'), findsOneWidget);
    expect(find.byType(UiKitView), findsNothing);
    expect(find.byKey(loadingKey), findsNothing);
    expect(skipped.single, isA<PaywallSkippedReasonHoldout>());

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows the error builder with the error', (tester) async {
    final errors = <String>[];
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      onError: errors.add,
      errorBuilder: (context, error) => Text('error: $error'),
    )));

    await callView(created.single.hostId, 'onError', ['No paywall']);
    await tester.pump();

    expect(find.text('error: No paywall'), findsOneWidget);
    expect(find.byType(UiKitView), findsNothing);
    expect(errors, ['No paywall']);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('renders nothing by default when skipped or failed',
      (tester) async {
    await tester.pumpWidget(host(const PaywallView(placement: 'onboarding')));
    await callView(created.single.hostId, 'onSkip',
        [PPaywallSkippedReason.noAudienceMatch, null]);
    await tester.pump();
    expect(find.byType(UiKitView), findsNothing);
    expect(find.byType(SizedBox), findsNWidgets(2));

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('forwards loading state changes', (tester) async {
    final states = <PaywallLoadingState>[];
    await tester.pumpWidget(host(PaywallView(
        placement: 'onboarding', onLoadingStateChanged: states.add)));
    final hostId = created.single.hostId;

    for (final state in PPaywallLoadingState.values) {
      await callView(hostId, 'onLoadingStateChanged', [state]);
    }
    expect(states.map((e) => e.name),
        PPaywallLoadingState.values.map((e) => e.name));

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('answers custom callbacks, with a failure when there is no '
      'handler', (tester) async {
    await tester.pumpWidget(host(const PaywallView(placement: 'onboarding')));
    var reply = await callView(created.single.hostId, 'onCustomCallback',
        [PCustomCallback(name: 'validate')]);
    var result = reply!.single! as PCustomCallbackResult;
    expect(result.status, PCustomCallbackResultStatus.failure);
    expect(result.data, isNull);

    final callbacks = <CustomCallback>[];
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      onCustomCallback: (callback) async {
        callbacks.add(callback);
        return CustomCallbackResult.success({'valid': true});
      },
    )));
    // Changing only a callback keeps the platform view.
    expect(created, hasLength(1));
    reply = await callView(created.single.hostId, 'onCustomCallback', [
      PCustomCallback(name: 'validate', variables: {'email': 'a@b.c'})
    ]);
    result = reply!.single! as PCustomCallbackResult;
    expect(result.status, PCustomCallbackResultStatus.success);
    expect(result.data, {'valid': true});
    expect(callbacks.single.name, 'validate');
    expect(callbacks.single.variables, {'email': 'a@b.c'});

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('changing the placement recreates the view with a new host ID',
      (tester) async {
    final presented = <String?>[];
    Widget view(String placement) => host(PaywallView(
          placement: placement,
          loadingBuilder: loading,
          onPresent: (info) => presented.add(info.identifier),
        ));

    await tester.pumpWidget(view('first'));
    final first = created.single;
    await callView(first.hostId, 'onPresent', [PPaywallInfo(identifier: 'a')]);
    await tester.pump();
    expect(find.byKey(loadingKey), findsNothing);

    await tester.pumpWidget(view('second'));
    await tester.pump();
    expect(created, hasLength(2));
    final second = created.last;
    expect(second.hostId, isNot(first.hostId));
    expect(second.params['placement'], 'second');
    expect(disposed, [first.id]);
    // The new view starts out loading again.
    expect(find.byKey(loadingKey), findsOneWidget);

    // The old channel is gone, the new one is live.
    expect(
        await callView(
            first.hostId, 'onPresent', [PPaywallInfo(identifier: 'stale')]),
        isNull);
    expect(
        await callView(
            second.hostId, 'onPresent', [PPaywallInfo(identifier: 'b')]),
        isNotNull);
    expect(presented, ['a', 'b']);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('params are compared deeply', (tester) async {
    Widget view(Map<String, Object> params) =>
        host(PaywallView(placement: 'onboarding', params: params));

    await tester.pumpWidget(view({
      'a': 1,
      'nested': {
        'list': [1, 2]
      }
    }));
    await tester.pumpWidget(view({
      'a': 1,
      'nested': {
        'list': [1, 2]
      }
    }));
    expect(created, hasLength(1));

    await tester.pumpWidget(view({
      'a': 1,
      'nested': {
        'list': [1, 3]
      }
    }));
    expect(created, hasLength(2));
    expect(created.last.hostId, isNot(created.first.hostId));
    expect(created.last.params['params'], {
      'a': 1,
      'nested': {
        'list': [1, 3]
      }
    });

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('removing the widget unregisters its channel', (tester) async {
    await tester.pumpWidget(host(const PaywallView(placement: 'onboarding')));
    final view = created.single;
    expect(await callView(view.hostId, 'onLoadStart', []), isNotNull);

    await tester.pumpWidget(host(const SizedBox()));
    expect(disposed, [view.id]);
    expect(await callView(view.hostId, 'onLoadStart', []), isNull);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('claims gestures eagerly unless recognizers are given',
      (tester) async {
    await tester.pumpWidget(host(const PaywallView(placement: 'onboarding')));
    final eager = tester.widget<UiKitView>(find.byType(UiKitView));
    expect(eager.gestureRecognizers!.single.constructor(),
        isA<EagerGestureRecognizer>());

    await tester.pumpWidget(host(const PaywallView(
        placement: 'onboarding',
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{})));
    final none = tester.widget<UiKitView>(find.byType(UiKitView));
    expect(none.gestureRecognizers, isEmpty);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows the error state on unsupported platforms',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    await tester.pumpWidget(host(PaywallView(
      placement: 'onboarding',
      errorBuilder: (context, error) => Text(error),
    )));

    expect(created, isEmpty);
    expect(find.text('PaywallView is only available on Android and iOS.'),
        findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}

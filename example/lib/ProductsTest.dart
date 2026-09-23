import 'dart:io';

import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Exercises `getProducts`, `purchase` and `queryInAppPurchases` outside of a
/// paywall. Fetch products for a set of identifiers, tap one to purchase it,
/// then (Android only) query owned in-app purchases and consume them.
class ProductsTest extends StatefulWidget {
  @override
  _ProductsTestState createState() => _ProductsTestState();
}

class _ProductsTestState extends State<ProductsTest> {
  // Product identifiers configured for the example apps. iOS ids come from
  // ios/Runner/Products.storekit, Android ids from com.superwall.superapp.
  static final defaultProductIds = Platform.isIOS
      ? ['superwall_pro_3999', 'superwall_diamond_8999']
      : [
          'com.ui_tests.quarterly2',
          'com.ui_tests.monthly',
          'com.ui_tests.annual',
          'com.ui_tests.free_trial_annual',
        ];

  final productIdsController =
      TextEditingController(text: defaultProductIds.join(', '));

  bool isBusy = false;
  List<StoreProduct> products = [];
  List<OwnedInAppPurchase> ownedPurchases = [];
  final List<String> log = [];

  @override
  void dispose() {
    productIdsController.dispose();
    super.dispose();
  }

  void _log(String message) {
    setState(() {
      log.insert(
          0,
          '${DateTime.now().toIso8601String().substring(11, 19)} '
          '$message');
    });
  }

  Future<void> _run(String label, Future<void> Function() action) async {
    if (isBusy) return;
    setState(() => isBusy = true);
    try {
      await action();
    } catch (e) {
      _log('$label failed: $e');
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  Future<void> _fetchProducts() => _run('getProducts', () async {
        final ids = productIdsController.text
            .split(',')
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();
        _log('getProducts($ids)');
        final result = await Superwall.shared.getProducts(ids);
        setState(() => products = result);
        _log('getProducts returned ${result.length} product(s): '
            '${result.map((p) => p.productIdentifier).toList()}');
        final missing = ids
            .where((id) => !result.any((p) => p.productIdentifier == id))
            .toList();
        if (missing.isNotEmpty) {
          _log('Not found in store: $missing');
        }
      });

  Future<void> _purchase(StoreProduct product) => _run('purchase', () async {
        _log('purchase(${product.productIdentifier})');
        final result =
            await Superwall.shared.purchase(product.productIdentifier);
        _log('purchase result: ${_describePurchaseResult(result)}');
      });

  Future<void> _queryInAppPurchases() => _run('queryInAppPurchases', () async {
        _log('queryInAppPurchases()');
        final result = await Superwall.shared.queryInAppPurchases();
        setState(() => ownedPurchases = result);
        _log('queryInAppPurchases returned ${result.length} purchase(s)');
        for (final purchase in result) {
          _log('  $purchase token=${_shortToken(purchase.purchaseToken)}');
        }
      });

  Future<void> _consume(OwnedInAppPurchase purchase) =>
      _run('consume', () async {
        _log('consume(${_shortToken(purchase.purchaseToken)}) '
            'for ${purchase.productIds}');
        final result = await Superwall.shared.consume(purchase.purchaseToken);
        _log('consume result: $result');
      });

  String _describePurchaseResult(PurchaseResult result) => switch (result) {
        PurchaseResultPurchased() => 'purchased',
        PurchaseResultCancelled() => 'cancelled',
        PurchaseResultPending() => 'pending',
        PurchaseResultFailed(error: final error) => 'failed ($error)',
      };

  String _shortToken(String token) =>
      token.length > 12 ? '${token.substring(0, 12)}…' : token;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Products Test')),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(12),
                children: [
                  TextField(
                    controller: productIdsController,
                    decoration: InputDecoration(
                      labelText: 'Product IDs (comma separated)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    key: Key('fetchProducts'),
                    onPressed: isBusy ? null : _fetchProducts,
                    child: Text('Fetch products'),
                  ),
                  if (products.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text('Tap a product to purchase it',
                        style: Theme.of(context).textTheme.bodySmall),
                    for (final product in products)
                      Card(
                        child: ListTile(
                          key: Key('product_${product.productIdentifier}'),
                          title: Text(product.productIdentifier),
                          subtitle: Text(
                            '${product.localizedPrice} '
                            '${product.currencyCode ?? ''} · '
                            'period: ${product.period} '
                            '(${product.localizedSubscriptionPeriod})'
                            '${product.hasFreeTrial ? ' · trial: ${product.trialPeriodText}' : ''}',
                          ),
                          trailing: Icon(Icons.shopping_cart),
                          onTap: isBusy ? null : () => _purchase(product),
                        ),
                      ),
                  ],
                  Divider(height: 24),
                  ElevatedButton(
                    key: Key('queryInAppPurchases'),
                    onPressed: !isBusy && Platform.isAndroid
                        ? _queryInAppPurchases
                        : null,
                    child: Text(Platform.isAndroid
                        ? 'Query in-app purchases'
                        : 'Query in-app purchases (Android only)'),
                  ),
                  for (final purchase in ownedPurchases)
                    Card(
                      child: ListTile(
                        title: Text(purchase.productIds.join(', ')),
                        subtitle: Text(
                          'order: ${purchase.orderId ?? '-'} · '
                          'qty: ${purchase.quantity} · '
                          'acknowledged: ${purchase.isAcknowledged}\n'
                          '${purchase.purchaseTime}',
                        ),
                        isThreeLine: true,
                        trailing: TextButton(
                          onPressed: isBusy ? null : () => _consume(purchase),
                          child: Text('Consume'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.black87,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Output',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => setState(() => log.clear()),
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final line in log)
                          Text(
                            line,
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'monospace',
                                fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

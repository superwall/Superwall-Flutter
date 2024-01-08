import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// The product in the paywall.
class Product {
  final BridgeId bridgeId;

  Product({required this.bridgeId});

  // TODO
  // /// The type of product.
  // final ProductType type;
  //
  // /// The product identifier.
  // final String id;
}

/// The type of product.
enum ProductType {
  primary,
  secondary,
  tertiary,
}
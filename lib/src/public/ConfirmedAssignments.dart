import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

class Variant {
  final String id;
  final VariantType type;
  final String? paywallId;

  Variant({
    required this.id,
    required this.type,
    this.paywallId,
  });

  static Variant fromPigeon(PVariant pVariant) {
    return Variant(
      id: pVariant.id,
      type: VariantTypeExtension.fromPigeon(pVariant.type),
      paywallId: pVariant.paywallId,
    );
  }

  PVariant toPigeon() {
    return PVariant(
      id: id,
      type: VariantTypeExtension(type).toPigeon(),
      paywallId: paywallId,
    );
  }
}

enum VariantType {
  treatment,
  holdout,
}

extension VariantTypeExtension on VariantType {
  static VariantType fromPigeon(PVariantType type) {
    switch (type) {
      case PVariantType.treatment:
        return VariantType.treatment;
      case PVariantType.holdout:
        return VariantType.holdout;
    }
  }

  PVariantType toPigeon() {
    switch (this) {
      case VariantType.treatment:
        return PVariantType.treatment;
      case VariantType.holdout:
        return PVariantType.holdout;
    }
  }
}

class ConfirmedAssignment {
  final String experimentId;

  final Variant variant;

  ConfirmedAssignment({
    required this.experimentId,
    required this.variant,
  });

  static ConfirmedAssignment fromPigeon(PConfirmedAssignment pAssignment) {
    return ConfirmedAssignment(
      experimentId: pAssignment.experimentId,
      variant: Variant.fromPigeon(pAssignment.variant),
    );
  }

  PConfirmedAssignment toPigeon() {
    return PConfirmedAssignment(
      experimentId: experimentId,
      variant: variant.toPigeon(),
    );
  }
}

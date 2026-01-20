import '../generated/superwallhost.g.dart';
import '../generated/superwallhost.g.dart' as generated;

/// An enum specifying the store from which a product or entitlement originated.
enum ProductStore {
  appStore,
  stripe,
  paddle,
  playStore,
  superwall,
  other;

  static ProductStore fromPigeon(PProductStore pigeon) {
    switch (pigeon) {
      case PProductStore.appStore:
        return ProductStore.appStore;
      case PProductStore.stripe:
        return ProductStore.stripe;
      case PProductStore.paddle:
        return ProductStore.paddle;
      case PProductStore.playStore:
        return ProductStore.playStore;
      case PProductStore.superwall:
        return ProductStore.superwall;
      case PProductStore.other:
        return ProductStore.other;
    }
  }
}

/// An enum specifying the entitlement type.
enum EntitlementType {
  serviceLevel;

  static EntitlementType fromPigeon(PEntitlementType pigeon) {
    switch (pigeon) {
      case PEntitlementType.serviceLevel:
        return EntitlementType.serviceLevel;
    }
  }
}

/// The state of a subscription.
enum LatestSubscriptionState {
  inGracePeriod,
  subscribed,
  expired,
  inBillingRetryPeriod,
  revoked;

  static LatestSubscriptionState fromPigeon(PLatestSubscriptionState pigeon) {
    switch (pigeon) {
      case PLatestSubscriptionState.inGracePeriod:
        return LatestSubscriptionState.inGracePeriod;
      case PLatestSubscriptionState.subscribed:
        return LatestSubscriptionState.subscribed;
      case PLatestSubscriptionState.expired:
        return LatestSubscriptionState.expired;
      case PLatestSubscriptionState.inBillingRetryPeriod:
        return LatestSubscriptionState.inBillingRetryPeriod;
      case PLatestSubscriptionState.revoked:
        return LatestSubscriptionState.revoked;
    }
  }
}

/// The offer type for a subscription.
enum LatestSubscriptionOfferType {
  trial,
  code,
  promotional,
  winback;

  static LatestSubscriptionOfferType fromPigeon(
      PLatestSubscriptionOfferType pigeon) {
    switch (pigeon) {
      case PLatestSubscriptionOfferType.trial:
        return LatestSubscriptionOfferType.trial;
      case PLatestSubscriptionOfferType.code:
        return LatestSubscriptionOfferType.code;
      case PLatestSubscriptionOfferType.promotional:
        return LatestSubscriptionOfferType.promotional;
      case PLatestSubscriptionOfferType.winback:
        return LatestSubscriptionOfferType.winback;
    }
  }
}

/// A subscription transaction.
class SubscriptionTransaction {
  /// The unique identifier for the transaction.
  final String transactionId;

  /// The product identifier of the subscription.
  final String productId;

  /// The date that the store charged the user's account.
  final DateTime purchaseDate;

  /// Indicates whether the subscription will renew.
  final bool willRenew;

  /// Indicates whether the transaction has been revoked.
  final bool isRevoked;

  /// Indicates whether the subscription is in a billing grace period state.
  final bool isInGracePeriod;

  /// Indicates whether the subscription is in a billing retry period state.
  final bool isInBillingRetryPeriod;

  /// Indicates whether the subscription is active.
  final bool isActive;

  /// The date that the subscription expires, null if non-renewing.
  final DateTime? expirationDate;

  /// The type of offer that applies to the subscription transaction.
  final LatestSubscriptionOfferType? offerType;

  /// The subscription group identifier.
  final String? subscriptionGroupId;

  /// The store from which this transaction originated.
  final ProductStore? store;

  SubscriptionTransaction({
    required this.transactionId,
    required this.productId,
    required this.purchaseDate,
    required this.willRenew,
    required this.isRevoked,
    required this.isInGracePeriod,
    required this.isInBillingRetryPeriod,
    required this.isActive,
    this.expirationDate,
    this.offerType,
    this.subscriptionGroupId,
    this.store,
  });

  factory SubscriptionTransaction.fromPigeon(PSubscriptionTransaction pigeon) {
    return SubscriptionTransaction(
      transactionId: pigeon.transactionId,
      productId: pigeon.productId,
      purchaseDate:
          DateTime.fromMillisecondsSinceEpoch(pigeon.purchaseDate.toInt()),
      willRenew: pigeon.willRenew,
      isRevoked: pigeon.isRevoked,
      isInGracePeriod: pigeon.isInGracePeriod,
      isInBillingRetryPeriod: pigeon.isInBillingRetryPeriod,
      isActive: pigeon.isActive,
      expirationDate: pigeon.expirationDate != null
          ? DateTime.fromMillisecondsSinceEpoch(pigeon.expirationDate!.toInt())
          : null,
      offerType: pigeon.offerType != null
          ? LatestSubscriptionOfferType.fromPigeon(pigeon.offerType!)
          : null,
      subscriptionGroupId: pigeon.subscriptionGroupId,
      store: pigeon.store != null ? ProductStore.fromPigeon(pigeon.store!) : null,
    );
  }
}

/// A non-subscription transaction (consumable or non-consumable).
class NonSubscriptionTransaction {
  /// The unique identifier for the transaction.
  final String transactionId;

  /// The product identifier of the in-app purchase.
  final String productId;

  /// The date that the store charged the user's account.
  final DateTime purchaseDate;

  /// Indicates whether it's a consumable in-app purchase.
  final bool isConsumable;

  /// Indicates whether the transaction has been revoked.
  final bool isRevoked;

  /// The store from which this transaction originated.
  final ProductStore? store;

  NonSubscriptionTransaction({
    required this.transactionId,
    required this.productId,
    required this.purchaseDate,
    required this.isConsumable,
    required this.isRevoked,
    this.store,
  });

  factory NonSubscriptionTransaction.fromPigeon(
      PNonSubscriptionTransaction pigeon) {
    return NonSubscriptionTransaction(
      transactionId: pigeon.transactionId,
      productId: pigeon.productId,
      purchaseDate:
          DateTime.fromMillisecondsSinceEpoch(pigeon.purchaseDate.toInt()),
      isConsumable: pigeon.isConsumable,
      isRevoked: pigeon.isRevoked,
      store: pigeon.store != null ? ProductStore.fromPigeon(pigeon.store!) : null,
    );
  }
}

/// An entitlement that represents a subscription tier in your app.
class Entitlement {
  /// The identifier for the entitlement.
  final String id;

  /// The type of entitlement.
  final EntitlementType type;

  /// Indicates whether there is any active, non-revoked transaction for this entitlement.
  final bool isActive;

  /// All product identifiers that map to the entitlement.
  final List<String> productIds;

  /// The product identifier of the latest transaction to unlock this entitlement.
  final String? latestProductId;

  /// The store from which this entitlement was granted.
  final ProductStore? store;

  /// The purchase date of the first transaction that unlocked this entitlement.
  final DateTime? startsAt;

  /// The date that the entitlement was last renewed.
  final DateTime? renewedAt;

  /// The expiry date of the last transaction that unlocked this entitlement.
  final DateTime? expiresAt;

  /// Indicates whether the entitlement is active for a lifetime due to a non-consumable purchase.
  final bool? isLifetime;

  /// Indicates whether the last subscription transaction will auto renew.
  final bool? willRenew;

  /// The state of the last subscription transaction.
  final LatestSubscriptionState? state;

  /// The type of offer that applies to the last subscription transaction.
  final LatestSubscriptionOfferType? offerType;

  Entitlement({
    required this.id,
    this.type = EntitlementType.serviceLevel,
    this.isActive = true,
    this.productIds = const [],
    this.latestProductId,
    this.store,
    this.startsAt,
    this.renewedAt,
    this.expiresAt,
    this.isLifetime,
    this.willRenew,
    this.state,
    this.offerType,
  });

  factory Entitlement.fromPigeon(PEntitlement pigeon) {
    return Entitlement(
      id: pigeon.id,
      type: EntitlementType.fromPigeon(pigeon.type),
      isActive: pigeon.isActive,
      productIds: pigeon.productIds,
      latestProductId: pigeon.latestProductId,
      store:
          pigeon.store != null ? ProductStore.fromPigeon(pigeon.store!) : null,
      startsAt: pigeon.startsAt != null
          ? DateTime.fromMillisecondsSinceEpoch(pigeon.startsAt!.toInt())
          : null,
      renewedAt: pigeon.renewedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(pigeon.renewedAt!.toInt())
          : null,
      expiresAt: pigeon.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(pigeon.expiresAt!.toInt())
          : null,
      isLifetime: pigeon.isLifetime,
      willRenew: pigeon.willRenew,
      state: pigeon.state != null
          ? LatestSubscriptionState.fromPigeon(pigeon.state!)
          : null,
      offerType: pigeon.offerType != null
          ? LatestSubscriptionOfferType.fromPigeon(pigeon.offerType!)
          : null,
    );
  }

  PEntitlement toPigeon() {
    return PEntitlement(
      id: id,
      type: _toPEntitlementType(type),
      isActive: isActive,
      productIds: productIds,
      latestProductId: latestProductId,
      store: store != null ? _toPProductStore(store!) : null,
      startsAt: startsAt?.millisecondsSinceEpoch,
      renewedAt: renewedAt?.millisecondsSinceEpoch,
      expiresAt: expiresAt?.millisecondsSinceEpoch,
      isLifetime: isLifetime,
      willRenew: willRenew,
      state: state != null ? _toPLatestSubscriptionState(state!) : null,
      offerType: offerType != null ? _toPLatestSubscriptionOfferType(offerType!) : null,
    );
  }

  /// Merges entitlements by ID using priority-based deduplication.
  /// When multiple entitlements share the same ID, keeps the one with highest priority.
  ///
  /// Priority rules (in order):
  /// 1. Active entitlements win over inactive
  /// 2. Entitlements with transaction history win
  /// 3. Lifetime entitlements win
  /// 4. Non-revoked entitlements win
  /// 5. Latest renewal date wins
  /// 6. Latest expiration date wins
  static Set<Entitlement> mergePrioritized(Set<Entitlement> entitlements) {
    final Map<String, Entitlement> dict = {};

    for (final entitlement in entitlements) {
      final existing = dict[entitlement.id];
      if (existing != null) {
        dict[entitlement.id] = entitlement._priority(comparing: existing);
      } else {
        dict[entitlement.id] = entitlement;
      }
    }

    return dict.values.toSet();
  }

  /// Compares this entitlement with another and returns the one with higher priority.
  Entitlement _priority({required Entitlement comparing}) {
    // 1. Active wins over inactive
    if (isActive != comparing.isActive) {
      return isActive ? this : comparing;
    }

    // 2. Has transaction history wins
    final selfHasHistory = latestProductId != null;
    final otherHasHistory = comparing.latestProductId != null;
    if (selfHasHistory != otherHasHistory) {
      return selfHasHistory ? this : comparing;
    }

    // 3. Lifetime wins
    final selfIsLifetime = isLifetime ?? false;
    final otherIsLifetime = comparing.isLifetime ?? false;
    if (selfIsLifetime != otherIsLifetime) {
      return selfIsLifetime ? this : comparing;
    }

    // 4. Non-revoked wins
    final selfIsRevoked = state == LatestSubscriptionState.revoked;
    final otherIsRevoked = comparing.state == LatestSubscriptionState.revoked;
    if (selfIsRevoked != otherIsRevoked) {
      return selfIsRevoked ? comparing : this;
    }

    // 5. Latest renewal wins
    if (renewedAt != null && comparing.renewedAt != null) {
      return renewedAt!.isAfter(comparing.renewedAt!) ? this : comparing;
    }

    // 6. Latest expiration wins
    if (expiresAt != null && comparing.expiresAt != null) {
      return expiresAt!.isAfter(comparing.expiresAt!) ? this : comparing;
    }

    // Default to self
    return this;
  }

  static PEntitlementType _toPEntitlementType(EntitlementType type) {
    return PEntitlementType.serviceLevel;
  }

  static PProductStore _toPProductStore(ProductStore store) {
    switch (store) {
      case ProductStore.appStore:
        return PProductStore.appStore;
      case ProductStore.stripe:
        return PProductStore.stripe;
      case ProductStore.paddle:
        return PProductStore.paddle;
      case ProductStore.playStore:
        return PProductStore.playStore;
      case ProductStore.superwall:
        return PProductStore.superwall;
      case ProductStore.other:
        return PProductStore.other;
    }
  }

  static PLatestSubscriptionState _toPLatestSubscriptionState(LatestSubscriptionState state) {
    switch (state) {
      case LatestSubscriptionState.inGracePeriod:
        return PLatestSubscriptionState.inGracePeriod;
      case LatestSubscriptionState.subscribed:
        return PLatestSubscriptionState.subscribed;
      case LatestSubscriptionState.expired:
        return PLatestSubscriptionState.expired;
      case LatestSubscriptionState.inBillingRetryPeriod:
        return PLatestSubscriptionState.inBillingRetryPeriod;
      case LatestSubscriptionState.revoked:
        return PLatestSubscriptionState.revoked;
    }
  }

  static PLatestSubscriptionOfferType _toPLatestSubscriptionOfferType(LatestSubscriptionOfferType offerType) {
    switch (offerType) {
      case LatestSubscriptionOfferType.trial:
        return PLatestSubscriptionOfferType.trial;
      case LatestSubscriptionOfferType.code:
        return PLatestSubscriptionOfferType.code;
      case LatestSubscriptionOfferType.promotional:
        return PLatestSubscriptionOfferType.promotional;
      case LatestSubscriptionOfferType.winback:
        return PLatestSubscriptionOfferType.winback;
    }
  }
}

/// Contains the latest subscription and entitlement info about the customer.
class CustomerInfo {
  /// The subscription transactions the user has made.
  final List<SubscriptionTransaction> subscriptions;

  /// The non-subscription transactions the user has made.
  final List<NonSubscriptionTransaction> nonSubscriptions;

  /// All entitlements available to the user.
  final List<Entitlement> entitlements;

  /// The ID of the user.
  final String userId;

  CustomerInfo({
    required this.subscriptions,
    required this.nonSubscriptions,
    required this.entitlements,
    required this.userId,
  });

  factory CustomerInfo.fromPigeon(PCustomerInfo pigeon) {
    return CustomerInfo(
      subscriptions: pigeon.subscriptions
          .map((e) => SubscriptionTransaction.fromPigeon(e))
          .toList(),
      nonSubscriptions: pigeon.nonSubscriptions
          .map((e) => NonSubscriptionTransaction.fromPigeon(e))
          .toList(),
      entitlements:
          pigeon.entitlements.map((e) => Entitlement.fromPigeon(e)).toList(),
      userId: pigeon.userId,
    );
  }
}

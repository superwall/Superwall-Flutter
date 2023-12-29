/// The product involved in the transaction.
class TransactionProduct {
  /// The product identifier.
  final String id;

  TransactionProduct({required this.id});

  factory TransactionProduct.fromJson(Map<dynamic, dynamic> json) {
    return TransactionProduct(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
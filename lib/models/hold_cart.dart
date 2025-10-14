class HoldCart {
  final int? id;
  final String name;
  final String customer;
  final String date;
  final double totalValAmount;
  final double discountAmount;
  final double discountPercent;
  final double vat;
  final double totalAmount;
  final int totalQty;

  HoldCart({
    this.id,
    required this.name,
    required this.customer,
    required this.date,
    required this.totalValAmount,
    required this.discountAmount,
    required this.discountPercent,
    required this.vat,
    required this.totalAmount,
    required this.totalQty,
  });

  // From JSON (e.g. from database or API)
  factory HoldCart.fromJson(Map<String, dynamic> json) {
    return HoldCart(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      customer: json['customer'] ?? '',
      date: json['date'] ?? '',
      totalValAmount: (json['total_val_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      discountPercent: (json['discount_percent'] ?? 0).toDouble(),
      vat: (json['vat'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalQty: json['total_qty'] ?? 0,
    );
  }

  // To JSON (e.g. for saving or sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customer': customer,
      'date': date,
      'total_val_amount': totalValAmount,
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'vat': vat,
      'total_amount': totalAmount,
      'total_qty': totalQty,
    };
  }
}

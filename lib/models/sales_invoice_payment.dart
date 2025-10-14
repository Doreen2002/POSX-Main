class Payments {
  final String name;
  final String modeOfPayment;
  final double amount;
  final String openingEntry;

  Payments({
    required this.name,
    required this.modeOfPayment,
    required this.amount,
    required this.openingEntry,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mode_of_payment': modeOfPayment,
      'amount': amount,
      'opening_entry': openingEntry,
    };
  }
}

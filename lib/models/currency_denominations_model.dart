class CurrencyDenomination {
  final String currencyDenominationId;
  final String currencyName;
  final double denominationValue;

  CurrencyDenomination({
    required this.currencyDenominationId,
    required this.currencyName,
    required this.denominationValue,
  });

  // From JSON
  factory CurrencyDenomination.fromJson(Map<String, dynamic> json) {
    return CurrencyDenomination(
      currencyDenominationId: json['currency_denomination_id'],
      currencyName: json['currency_name'],
      denominationValue: (json['denomination_value'] as num).toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'currency_denomination_id': currencyDenominationId,
      'currency_name': currencyName,
      'denomination_value': denominationValue,
    };
  }
}

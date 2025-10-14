import 'dart:ffi';

class PosClosingCurrencyDenomination {
  final int id;
  final String posClosing;
  final double denominationValue;
  final double totalDenominationValue;
  final int count ;

  PosClosingCurrencyDenomination({
    required this.id,
    required this.posClosing,
    required this.denominationValue,
    required this.totalDenominationValue,
    required this.count
  });


  factory PosClosingCurrencyDenomination.fromJson(Map<String, dynamic> json) {
    return PosClosingCurrencyDenomination(
      id: json['id'] ,
      posClosing: json['pos_closing'] as String,
      denominationValue: (json['denomination_value'] as num).toDouble(),
      totalDenominationValue: (json['total_denomination_value'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pos_closing': posClosing,
      'denomination_value': denominationValue,
      'total_denomination_value': totalDenominationValue,
      'count':count
    };
  }
}

class BarcodeModel {
  final String barcode;
  final String itemCode;
  final String? barcodeType;
  final String? uom;
  final double rate;

  BarcodeModel({
    
     this.barcodeType,
     this.uom,
     required this.barcode,
    required this.itemCode,
    required this.rate,
  });


  factory BarcodeModel.fromJson(Map<String, dynamic> json) {
    return BarcodeModel(
      barcode: json['barcode'] ?? '',
      barcodeType: json['barcode_type'] ?? '',
      uom: json['uom'] ?? '',
      itemCode: json['item_code'] ?? '',
      rate: json['rate'] != null ? double.tryParse(json['rate'].toString()) ?? 0.0 : 0.0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'barcode_type': barcodeType,
      'uom': uom,
      'item_code': itemCode,
      'rate': rate,
    };
  }
}

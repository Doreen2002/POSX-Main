class BarcodeModel {
  final String barcode;
  final String itemCode;
  final String? barcodeType;
  final String? uom;

  BarcodeModel({
    
     this.barcodeType,
     this.uom,
     required this.barcode,
    required this.itemCode,
  });


  factory BarcodeModel.fromJson(Map<String, dynamic> json) {
    return BarcodeModel(
      barcode: json['barcode'] ?? '',
      barcodeType: json['barcode_type'] ?? '',
      uom: json['uom'] ?? '',
      itemCode: json['item_code'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'barcode_type': barcodeType,
      'uom': uom,
      'item_code': itemCode,
    };
  }
}

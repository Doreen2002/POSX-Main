class HoldCartItem {
  final int? id;
  final String name;
  final String parentId;
  final String? date;
  final double? rate;
  final int? qty;
  final int idx;
  final String? itemCode;
  final String? itemName;
  final String? itemGroup;
  final String? stockUom;
  final double? discountAmount;
  final double?  discountPercent;
  final int? openingStock;
  final double?  rateWithVat;
  final int? vat;
  final double? totalAmount;
  final String? batchNo;
  final String? serialNo;
  final String? batchExpiryDate;

  HoldCartItem({
    this.id,
    required this.name,
    required this.parentId,
    required this.idx,
     this.date,
     this.rate,
     this.qty,
     this.itemCode,
     this.itemName,
     this.itemGroup,
     this.stockUom,
     this.discountAmount,
     this.discountPercent,
     this.openingStock,
     this.rateWithVat,
     this.vat,
     this.totalAmount,
    this.batchNo,
    this.serialNo,
    this.batchExpiryDate,
  });

  // Deserialize from JSON
  factory HoldCartItem.fromJson(Map<String, dynamic> json) {
    return HoldCartItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? '',
      idx: json['idx'] ?? 0,
      date: json['date'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      qty: json['qty'] ?? 0,
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      itemGroup: json['item_group'] ?? '',
      stockUom: json['stock_uom'] ?? '',
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      discountPercent: (json['discount_percent'] ?? 0).toDouble(),
      openingStock: json['opening_stock'] ?? 0,
      rateWithVat: (json['rate_with_vat'] ?? 0).toDouble(),
      vat: (json['vat'] ?? 0).toInt(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      batchNo: json['batch_no'],
      serialNo: json['serial_no'],  
      batchExpiryDate: json['batch_expiry_date'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'date': date,
      'rate': rate,
      'qty': qty,
      'item_code': itemCode,
      'item_name': itemName,
      'item_group': itemGroup,
      'stock_uom': stockUom,
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'opening_stock': openingStock,
      'rate_with_vat': rateWithVat,
      'vat': vat,
      'total_amount': totalAmount,
      'batch_no': batchNo,
      'serial_no': serialNo,
      'batch_expiry_date': batchExpiryDate,
      'idx': idx,
    };
  }
}

// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  String name;
  String itemCode;
  String itemName;
  String itemGroup;
  String stockUom;
  String image;
  int qty;
  double itemTotal; // Line total (qty × rate), not unit cost
  double newRate;
  int? openingStock;
  int? hasBatchNo;
  int? hasSerialNo;
  int? createNewBatch;
  String? batchNumberSeries;
  String? serialNo;
  String? warehouse;
  int? hasExpiryDate;
  dynamic batchQty;
  int? serialQty;
  int? vatValue;
  double? singleItemDiscAmount;
  double? ItemDiscAmount;
  double? singleItemDiscPer;
  double? countedVatValue;
  double? initialCountedVatValue;
  double? vatValueAmount;
  double? totalWithVat;
  double? totalWithVatPrev;
  double? totalWithoutVat;
  double? grandTotal;
  double? netTotal;
  int? totalQuantity;
  double? newNetRate;
  double? newNetAmount;
  int? isScanned;
  double? maxDiscount;
  dynamic customVATInclusive;
  dynamic vatExclusiveRate;
  dynamic originalRate;
  
  // ✅ NEW: Pricing rule tracking fields
  bool? hasPricingRuleApplied;
  String? appliedPricingRuleId;
  String? appliedPricingRuleTitle;
  String discountSource;   // 'manual', 'pricing_rule', 'none'
  
  // PLU for barcode lookup only
  String? plu;
  Item({
    required this.name,
    required this.itemCode,
    required this.itemName,
    required this.itemGroup,
    required this.stockUom,
    required this.image,
    required this.qty,
    required this.itemTotal,
    required this.newRate,
    this.openingStock,
    this.hasBatchNo,
    this.hasSerialNo,
    this.createNewBatch,
    this.batchNumberSeries,
    this.hasExpiryDate,
    this.serialNo,
    this.warehouse,
    this.batchQty,
    this.serialQty,
    this.vatValue,
    this.singleItemDiscAmount,
    this.ItemDiscAmount,
    this.singleItemDiscPer,
    this.countedVatValue,
    this.initialCountedVatValue,
    this.vatValueAmount,
    this.totalWithVat,
    this.totalWithVatPrev,
    this.totalWithoutVat,
    this.grandTotal,
    this.netTotal,
    this.totalQuantity,
    this.newNetRate,
    this.newNetAmount,
    this.isScanned,
    this.maxDiscount,
    this.vatExclusiveRate,
    this.customVATInclusive,
    this.originalRate,
    // PLU for barcode lookup
    this.plu,
    // ✅ NEW: Pricing rule fields with defaults
    this.hasPricingRuleApplied,
    this.appliedPricingRuleId,
    this.appliedPricingRuleTitle,
    this.discountSource = 'none',
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"],
    itemCode: json["item_code"],
    itemName: json["item_name"],
    itemGroup: json["item_group"],
    stockUom: json["stock_uom"],
    image: json["image"],
    qty: json["qty"],
    itemTotal: json["valuation_rate"],
    originalRate: json["valuation_rate"]?.toDouble() ?? 0.0,
    newRate: json["new_rate"]?.toDouble(),
    openingStock: json["opening_stock"]?.toDouble(),
    hasBatchNo : json['has_batch_no'],
    hasSerialNo : json['has_serial_no'],
    serialNo : json['serial_no'],
    singleItemDiscAmount : json['single_item_disc_amount'],
    ItemDiscAmount : json['item_disc_amount'],
    singleItemDiscPer : json['single_item_disc_per'],
    createNewBatch : json['create_new_batch'],
    batchNumberSeries : json['batch_number_seres'],
    hasExpiryDate : json['has_expiry_date'],
    batchQty : json['batch_qty'],
    warehouse: json['warehouse'],
    serialQty : json['serial_qty'],
    vatValue : json['vat_value'],
    countedVatValue : json['counted_vat_value'],
    initialCountedVatValue : json['initial_counted_vat_value'],
    vatValueAmount : json['vat_value_amount'],
    totalWithVat : json['total_with_vat'],
    totalWithVatPrev : json['total_with_vat_prev'],
    totalWithoutVat : json['total_without_vat'],
    grandTotal : json['grand_total'],
    netTotal : json['net_total'],
    totalQuantity : json['total_quantity'],
    newNetRate : json['new_net_rate'],
    newNetAmount : json['new_net_amount'],
    isScanned : json['is_scanned'],
    maxDiscount: json['max_discount']?.toDouble() ?? 0.0,
    customVATInclusive: json['custom_is_vat_inclusive'].toInt() ?? 0,
    vatExclusiveRate: json['vat_exclusive_rate']?.toDouble() ?? 0,
    // PLU for barcode lookup
    plu: json['plu'],
    // ✅ NEW: Pricing rule fields
    hasPricingRuleApplied: json['has_pricing_rule_applied'] ?? false,
    appliedPricingRuleId: json['applied_pricing_rule_id'],
    appliedPricingRuleTitle: json['applied_pricing_rule_title'],
    discountSource: json['discount_source'] ?? 'none',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "item_code": itemCode,
    "item_name": itemName,
    "item_group": itemGroup,
    "stock_uom": stockUom,
    "image": image,
    "qty": qty,
    "valuation_rate": itemTotal,
    "new_rate": newRate,
    "opening_stock": openingStock,
    "has_batch_no": hasBatchNo,
    "has_serial_no": hasSerialNo,
    "single_item_disc_amount": singleItemDiscAmount,
    "item_disc_amount": ItemDiscAmount,
    "single_item_disc_per": singleItemDiscPer,
    "serial_no": serialNo,
    "warehouse": warehouse,
    "create_new_batch": createNewBatch,
    "batch_number_seres": batchNumberSeries,
    "has_expiry_date":hasExpiryDate,
    "batch_qty":batchQty,
    "serial_qty":serialQty,
    "vat_value":vatValue,
    "counted_vat_value":countedVatValue,
    "initial_counted_vat_value":initialCountedVatValue,
    "vat_value_amount":vatValueAmount,
    "total_with_vat":totalWithVat,
    "total_with_vat_prev":totalWithVatPrev,
    "total_without_vat":totalWithoutVat,
    "grand_total":grandTotal,
    "net_Total" :netTotal,
    "total_Quantity" : totalQuantity,
    'new_net_rate':newNetRate,
    'new_net_amount':newNetAmount,
    'is_scanned':isScanned,
    'max_discount': maxDiscount,
    'custom_is_vat_inclusive': customVATInclusive,
    'vat_exclusive_rate': vatExclusiveRate,
    'original_rate': originalRate,
    // PLU for barcode lookup
    'plu': plu,
    // ✅ NEW: Pricing rule fields
    'has_pricing_rule_applied': hasPricingRuleApplied,
    'applied_pricing_rule_id': appliedPricingRuleId,
    'applied_pricing_rule_title': appliedPricingRuleTitle,
    'discount_source': discountSource,
  };
}

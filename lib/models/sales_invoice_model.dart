class TempSalesInvoiceModel {
  final String? id;
  final String name;
  final String customer;
  final String posProfile;
  final String company;
  final String postingDate;
  final String postingTime;
  final String dueDate;
  final double netTotal;
  final double additionalDiscountPercentage;
  final double grandTotal;
  final String status;
  final String messageStatus;
  final double vat;
  final double discount;
  final String openingName;
  final String? erpnextID;
  final String? invoiceStatus;
  final String? isReturn;
  final String? returnAgainst;
  TempSalesInvoiceModel({
    this.id,
    required this.name,
    required this.customer,
    required this.posProfile,
    required this.company,
    required this.postingDate,
    required this.postingTime,
    required this.dueDate,
    required this.netTotal,
    required this.additionalDiscountPercentage,
    required this.grandTotal,
    required this.status,
    required this.messageStatus,
    required this.vat,
    required this.discount,
    required this.openingName,
    this.erpnextID,
    this.invoiceStatus,
    this.isReturn,
    this.returnAgainst,
  });

 factory TempSalesInvoiceModel.fromJson(Map<String, dynamic> json) {
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  return TempSalesInvoiceModel(
    id: json['id'],
    name: json['name'],
    customer: json['customer'],
    posProfile: json['pos_profile'],
    company: json['company'],
    postingDate: json['posx_date'],
    postingTime: json['erpnext_si_date'],
    dueDate: json['due_date'],
    netTotal: parseDouble(json['net_total']),
    additionalDiscountPercentage: parseDouble(json['additional_discount_percentage']),
    grandTotal: parseDouble(json['grand_total']),
    status: json['status'],
    messageStatus: json['messageStatus'],
    vat: parseDouble(json['vat']),
    discount: parseDouble(json['discount']),
    openingName: json['opening_name'],
    erpnextID : json['erpnext_id'],
    invoiceStatus: json['invoice_status'] ?? "Submitted", 
    isReturn: json['is_return'],
    returnAgainst: json['return_against'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customer': customer,
      'pos_profile': posProfile,
      'company': company,
      'posx_date': postingDate,
      'erpnext_si_date': postingTime,
      'due_date': dueDate,
      'net_total': netTotal,
      'additional_discount_percentage': additionalDiscountPercentage,
      'grand_total': grandTotal,
      'status': status,
      'messageStatus': messageStatus,
      'vat': vat,
      'discount': discount,
      'opening_name': openingName,
      'erpnext_id': erpnextID,
      'invoice_status': invoiceStatus ?? "Submitted",
      'is_return': isReturn,  
      'return_against': returnAgainst,
    };
  }
}


class TempSalesInvoiceItemModel {
  final int id;
  final String name;
  final String itemName;
  final String itemCode;
  final String? image;
  final String stockUOM;
  final double rate;


  TempSalesInvoiceItemModel({
    required this.id,
    required this.name,
    required this.itemCode,
    required this.itemName,
    this.image,
    required this.stockUOM,
    required this.rate

  });


  factory TempSalesInvoiceItemModel.fromJson(Map<String, dynamic> json) {
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  return TempSalesInvoiceItemModel(
    id: json['id'],
    name: json['name'],
    itemCode: json['item_code'],
    itemName: json['item_name'],
    stockUOM: json['stock_uom'],
    rate:json['rate']
   
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'item_code':itemCode,
      'item_name':itemName,
      'stock_uom':stockUOM,
      'rate':rate
    };
  }

}
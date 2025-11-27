class ItemPrice {
 String name;
 String  itemCode;
 String UOM;
 String priceList;
 double priceListRate;
 String? customer;
 String? batchNo;
 String? validFrom;
 String? validTo;

ItemPrice({
  required this.name,
  required this.itemCode,
  required this.UOM,
  required this.priceList,
  required this.priceListRate,
  this.customer,
  this.batchNo,
  this.validFrom,
  this.validTo,

});

factory ItemPrice.fromJson(Map<String , dynamic> json)
{
  return ItemPrice(
    name: json['name'] ?? '',
    itemCode: json['item_code'] ?? '',
    UOM: json['uom'] ?? '',
    priceList: json['price_list'] ?? '',
    priceListRate: (json['price_list_rate'] != null) ? double.tryParse(json['price_list_rate'].toString()) ?? 0.0 : 0.0,
    customer: json['customer'],
    batchNo: json['batch_no'],
    validFrom: json['valid_from'],
    validTo: json['valid_to'],
  );
}
Map <String , dynamic> toJson(){
  return {
    'name': name,
    'item_code': itemCode,
    'uom': UOM,
    'price_list': priceList,
    'price_list_rate': priceListRate,
    'customer': customer,
    'batch_no': batchNo,
    'valid_from': validFrom,
    'valid_to': validTo,
  };
}
}

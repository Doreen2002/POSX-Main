class UOM {
 String name;
 String itemCode;
 String uom;
double conversionFactor;


UOM({
  required this.name,
  required this.itemCode,
  required this.conversionFactor,
  required this.uom


});

factory UOM.fromJson(Map<String , dynamic> json)
{
  return UOM(
    name: json['name'] ?? '',
    uom:json['uom'],
    itemCode: json['item_code'] ?? '',
    conversionFactor: json['conversion_factor'] ?? 0
  );
}
Map <String , dynamic> toJson(){
  return {
    'name': name,
    'uom':uom,
    'item_code': itemCode,
    'conversion_factor':conversionFactor

  };
}
}

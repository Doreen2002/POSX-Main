class UOM {
 String name;
 String itemCode;
 String uom;
double? conversionFactor;



UOM({
  required this.name,
  required this.itemCode,
  required this.uom,
  required this.conversionFactor,
  
   


});

factory UOM.fromJson(Map<String , dynamic> json)
{
  double parseConversion(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  return UOM(
    name: (json['name'] ?? '').toString(),
    itemCode: (json['item_code'] ?? '').toString(),
    uom: (json['uom'] ?? '').toString(),
    conversionFactor: parseConversion(json['conversion_factor'])
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

class UOM {
 String name;


UOM({
  required this.name,


});

factory UOM.fromJson(Map<String , dynamic> json)
{
  return UOM(
    name: json['name'] ?? '',
  );
}
Map <String , dynamic> toJson(){
  return {
    'name': name,

  };
}
}

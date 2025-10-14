class SalesPerson {
  final String name;
  final String fullName;

  SalesPerson({
    required this.name,
    required this.fullName,
  });

  // Factory constructor to create a SalesPerson from JSON
  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
      name: json['name'],
      fullName: json['full_name'],
    );
  }

  // Method to convert a SalesPerson to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_name': fullName,
    };
  }
}

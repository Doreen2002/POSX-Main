class User {
  final String name;
  final String fullName;
  final String username;
  final String password;

  User({
    required this.name,
    required this.fullName,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      fullName: json['full_name'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_name': fullName,
      'username': username,
      'password': password,
    };
  }
}

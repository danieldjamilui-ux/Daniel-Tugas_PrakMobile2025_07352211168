class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

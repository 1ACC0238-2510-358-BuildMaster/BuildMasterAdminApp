class User {
  final String id;
  final String email;
  final String name;
  final String role;

  User({required this.id, required this.email, required this.name, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
  );
}

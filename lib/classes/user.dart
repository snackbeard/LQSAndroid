class User {
  int userId;
  String name;
  String password;

  User({
    required this.userId,
    required this.name,
    required this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      password: json['password']
    );
  }

}
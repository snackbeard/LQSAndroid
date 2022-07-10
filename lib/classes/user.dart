import 'dart:async';
import 'dart:convert';

import 'package:air_sensor_app/infrastructure/appUrl.dart';
import 'package:http/http.dart' as http;

Future<User> login(User user) async {
  final response = await http.post(
    Uri.parse(AppUrl.buildUrl(AppUrl.userLogin, null)),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'name': user.name,
      'password': user.password
    }),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }

}

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
      userId: json['objectId'],
      name: json['name'],
      password: json['password']
    );
  }

}
import 'dart:convert';
import 'package:http/http.dart' as http;

// Модель данных для результата
class User {
  final int id;
  final String email;
  final String username;
  final String phone;
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['int'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
    );
  }
}
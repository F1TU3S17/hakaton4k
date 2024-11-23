import 'dart:convert';
import 'package:hakaton4k/modal/user.dart';
import 'package:http/http.dart' as http;


Future<User?> fetchUser(String token) async {
  const url = 'https://test-go-babich.amvera.io/user/profile'; // Замените на ваш URL

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'ApiKey $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return User.fromJson(responseBody);
    } else {
      print('Ошибка: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    print('Ошибка при запросе: $e');
  }

  return null; // Возвращаем null в случае ошибки
}

void main() async {
  const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzI0NjM3MDYsImlhdCI6MTczMjM3NzMwNiwidXNlcl9pZCI6IjEifQ.z7qWKsLMmUb3RXLp7wZQHB9AOsOjdFDmDFnCMk8B1V4';

  final user = await fetchUser(token);

  if (user != null) {
    print('ID: ${user.id}');
    print('Email: ${user.email}');
    print('Username: ${user.username}');
    print('Phone: ${user.phone}');
  } else {
    print('Не удалось получить данные пользователя');
  }
}

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
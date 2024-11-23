import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> registerUser({
  required String username,
  required String password,
  required String email,
  required String phone,
}) async {
  // URL для регистрации
  final url = Uri.parse('https://test-go-babich.amvera.io/auth/register');

  // Тело запроса
  final body = jsonEncode({
    "username": username,
    "password": password,
    "email": email,
    "phone": phone,
  });

  // Заголовки
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  try {
    // Отправляем POST-запрос
    final response = await http.post(url, headers: headers, body: body);
   // print(response);
    // Обрабатываем ответ
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Пользователь зарегистрирован успешно!');
      return response.body; // Возвращаем строку тела ответа
    } else {
      print('Ошибка регистрации: ${response.statusCode}');
    //  print('Ответ: ${response.body}');
      return 'Ошибка регистрации: ${response.body}'; // Возвращаем строку с ошибкой
    }
  } catch (e) {
    print('Ошибка при выполнении запроса: $e');
    return 'Ошибка: $e'; // Возвращаем строку с описанием ошибки
  }
}

  

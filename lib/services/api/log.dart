import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> loginUser({
  required String username,
  required String password,
}) async {
  // URL для логина
  final url = Uri.parse('https://test-go-babich.amvera.io/auth/login');

  // Тело запроса
  final body = jsonEncode({
    "email": username,
    "password": password,
  });

  // Заголовки
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  try {
    // Отправляем POST-запрос
    final response = await http.post(url, headers: headers, body: body);
    //print(response);

    // Обрабатываем ответ
    if (response.statusCode == 200) {
      print('Вход выполнен успешно!');
      // Декодируем тело ответа, чтобы получить токен
      final decodedResponse = jsonDecode(response.body);
      final token = decodedResponse['token']; // Предполагается, что токен хранится в ключе "token"
     // print('Токен: $token');
      return token; // Возвращаем токен
    } else {
      print('Ошибка входа: ${response.statusCode}');
      print('Ответ: ${response.body}');
      return 'Ошибка входа: ${response.body}'; // Возвращаем строку с ошибкой
    }
  } catch (e) {
    print('Ошибка при выполнении запроса: $e');
    return 'Ошибка: $e'; // Возвращаем строку с описанием ошибки
  }
}



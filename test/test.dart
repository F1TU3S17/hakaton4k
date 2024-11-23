import 'dart:convert';
import 'package:http/http.dart' as http;

Future getBalance(String token) async {
  final Uri url = Uri.parse('https://test-go-babich.amvera.io/user/operations/balance');

  // Выполнение GET запроса с передачей токена в заголовке
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'ApiKey $token',  // Передаем токен в заголовке
    },
  );

  if (response.statusCode == 200) {
    // Если запрос успешен, парсим JSON ответ
    return (json.decode(response.body)['amount']);
  }
  else if (response.statusCode == 500) {
    return 0;
  } 
  else {
    // Если произошла ошибка, выбрасываем исключение с кодом ошибки
    throw Exception('Failed to load balance. Status code: ${response.statusCode}');
  }
}

void main() async {
  try {
    String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzI0NzAwOTgsImlhdCI6MTczMjM4MzY5OCwidXNlcl9pZCI6IjEwIn0.tV26NoYXKvD0uhcq4GGMhRVyYM-Q6QHlztddZAbUF-c';
    var balance = await getBalance(token);
    print(balance); // Выводим полученные данные
  } catch (e) {
    print('Error: $e');
  }
}
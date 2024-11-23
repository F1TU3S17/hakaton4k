import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendChequeData(String token, String chequeData) async {
  // URL для отправки запроса
  final url = Uri.parse('https://test-go-babich.amvera.io/user/operations/cheque');
  
  // Заголовки
  final headers = {
    'Authorization': 'ApiKey $token',  // Используем токен, переданный как параметр
    'Content-Type': 'application/json',
  };

  // Данные для отправки
  final body = json.encode({
    'cheque_data': chequeData  // Используем данные чека, переданные как параметр
  });

  try {
    // Отправляем запрос POST
    final response = await http.post(url, headers: headers, body: body);

    // Обрабатываем ответ
    if (response.statusCode == 200) {
      print('Запрос успешно выполнен');
      print('Ответ от сервера: ${response.body}');
    } else {
      print('Ошибка: ${response.statusCode}');
      print('Ответ от сервера: ${response.body}');
    }
  } catch (e) {
    print('Произошла ошибка: $e');
  }
}

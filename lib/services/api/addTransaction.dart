import 'dart:convert'; // Подключаем библиотеку для работы с JSON
import 'package:hakaton4k/modal/transaction.dart';
import 'package:http/http.dart' as http;

Future<bool> postTransaction(Transaction transaction, String apiKey) async {
  final Uri url = Uri.parse('https://test-go-babich.amvera.io/user/operations');

  try {
    // Отправка POST запроса
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Устанавливаем тип контента
        'Authorization': 'ApiKey $apiKey', // Добавляем ApiKey в заголовок Authorization
      },
      body: jsonEncode(transaction.toJson()), // Преобразуем модель в JSON
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Проверка ответа от сервера
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      
      // Проверка, что в ответе res == "success"
      if (responseJson['res'] == 'success') {
        return true; // Успешный запрос
      } else {
        print('Ошибка в ответе сервера: ${responseJson['message']}');
      }
    } else {
      print('Ошибка запроса: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    print('Ошибка при отправке запроса: $e');
  }

  return false; // Ошибка или неуспешный запрос
}

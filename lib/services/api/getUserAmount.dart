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
 // print(response.statusCode);
  //print(token);
  if (response.statusCode == 200) {
    // Если запрос успешен, парсим JSON ответ
    return (json.decode(response.body)['amount']);
  }
  else if (response.statusCode == 500 || response.statusCode == 404) {
    return 0;
  } 
  else {
    // Если произошла ошибка, выбрасываем исключение с кодом ошибки
    //print('Failed to load balance. Status code: ${response.statusCode}');
    throw Exception('Failed to load balance. Status code: ${response.statusCode}');
  }
}
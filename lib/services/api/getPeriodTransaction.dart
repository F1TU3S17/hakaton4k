import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchTransactions(String token) async {
  final Uri url = Uri.parse('https://test-go-babich.amvera.io/user/operations/period'); // Укажите URL
  final String startDate = "2024-11-01";
  DateTime now = DateTime.now();
  DateTime end_date = now.add(Duration(days: 3));
  final String endDate = end_date.toIso8601String().split('T').first; // Текущая дата в формате "YYYY-MM-DD"
  print(endDate);
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'ApiKey $token', // Токен в заголовке
      },
      body: jsonEncode({
        "start_date": startDate.toString(),
        "end_date": endDate.toString(),
      }), 
    );

    if (response.statusCode == 200) {
      // Декодируем тело ответа
      final List<dynamic> jsonResponse = json.decode(response.body);

      // Преобразуем JSON в список карт
      return jsonResponse.map((transaction) => transaction as Map<String, dynamic>).toList();
    } else {
      // Обработка ошибок
      print('Ошибка: ${response.statusCode} - ${response.body}');
      return [];
    }
  } catch (e) {
    print('Ошибка при выполнении запроса: $e');
    return [];
  }
}
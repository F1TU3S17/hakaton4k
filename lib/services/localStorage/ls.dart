import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token); // Сохраняем токен
  print('Токен сохранен $token');
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // Получаем токен
}

Future<void> clearLocalStorage() async {
  // Получаем доступ к SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Очищаем все данные
  await prefs.clear();

  print('Локальное хранилище очищено.');
}

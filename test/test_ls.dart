import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token); // Сохраняем токен
  print('Токен сохранен');
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // Получаем токен
}

void main() async {
  await saveToken('123456');
  print(await getToken());
}
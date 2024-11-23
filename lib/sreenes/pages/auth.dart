import 'package:flutter/material.dart';
import 'package:hakaton4k/services/api/log.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/sreenes/mainScreen.dart';
import 'package:hakaton4k/sreenes/pages/register.dart'; // Убедитесь, что путь к MainScreen указан верно

class Auth extends StatelessWidget {
  Auth({super.key});

  // Контроллеры для текстовых полей
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          height: 400,
          width: 300,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: emailController,
                  cursorRadius: const Radius.circular(30),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[850],
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Email",
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // Цвет обычной границы
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // Цвет границы при фокусе
                        width: 2.0, // Толщина границы при фокусе
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[850],
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Пароль",
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // Цвет обычной границы
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // Цвет границы при фокусе
                        width: 2.0, // Толщина границы при фокусе
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Получаем значения из полей
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  // Проверяем, что поля не пустые
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Поля не должны быть пустыми')),
                    );
                    return;
                  }

                  print(email);
                  print(password);
                  // Выполняем функцию логина
                  String result = await loginUser(username: email.toString(), password: password.toString());
                  
                  print(result);
                  // Проверяем результат
                  if (result.contains('Ошибка')) {
                    // Показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: $result'), backgroundColor: Colors.yellow,),
                    );
                  } else {
                    await saveToken(result);
                    // Токен успешно получен, переходим на MainScreen
                    print('Авторизация успешна, токен: $result');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  minimumSize: const Size(100, 50), // Увеличиваем размер кнопки
                ),
                child: const Text('Войти'),
              ),
              const SizedBox(height: 20), // Добавляем отступ между кнопками
              InkWell(
                onTap: () => (Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    )), // Обработчик нажатия
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    color: Colors.yellow, // Цвет текста ссылки
                    decoration: TextDecoration.underline, // Подчеркивание
                    decorationColor: Colors.yellow,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

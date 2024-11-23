import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakaton4k/services/api/reg.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/sreenes/mainScreen.dart';
import 'package:hakaton4k/sreenes/pages/auth.dart';
import 'package:hakaton4k/sreenes/pages/homePage.dart';

// Форматировщик для телефона
class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Убираем все нецифровые символы
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Форматируем текст
    if (text.length > 3 && text.length <= 6) {
      text = '${text.substring(0, 3)} ${text.substring(3)}';
    } else if (text.length > 6 && text.length <= 8) {
      text =
          '${text.substring(0, 3)} ${text.substring(3, 6)}-${text.substring(6)}';
    } else if (text.length > 8 && text.length <= 10) {
      text =
          '${text.substring(0, 3)} ${text.substring(3, 6)}-${text.substring(6, 8)}-${text.substring(8)}';
    } else if (text.length > 10) {
      text =
          '${text.substring(0, 3)} ${text.substring(3, 6)}-${text.substring(6, 8)}-${text.substring(8, 10)}';
    }

    // Возвращаем новый форматированный текст
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Контроллеры для текстовых полей
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // Контроллер для телефона

  // Переменные для хранения значений
  String? _emailError;
  String? _phoneError; // Переменная для ошибки телефона
  String _login = ''; // Поле для хранения логина
  String _password = ''; // Поле для хранения пароля
  String _email = ''; // Поле для хранения email
  String _phone = ''; // Поле для хранения телефона

  bool _isChecked = false;

  @override
  void dispose() {
    // Освобождаем контроллеры при уничтожении виджета
    _loginController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Функция для изменения состояния галочки
  void _onChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  // Функция для валидации Email
  bool _validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Функция для валидации телефона (пример: проверка длины)
  bool _validatePhone(String phone) {
    // Убираем все нецифровые символы
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10; // Например, ожидаем 10 цифр после +7
  }

  // Функция регистрации
  void _onRegister() async {
    // Добавляем async
    setState(() {
      // Сохраняем значения из контроллеров
      _login = _loginController.text.trim();
      _password = _passwordController.text;
      _email = _emailController.text.trim();
      _phone = _phoneController.text.trim();

      // Валидация Email
      if (_email.isEmpty || !_validateEmail(_email)) {
        _emailError = 'Введите корректный Email';
      } else {
        _emailError = null; // Убираем ошибку, если Email корректный
      }

      // Валидация телефона
      if (_phone.isEmpty || !_validatePhone(_phone)) {
        _phoneError = 'Введите корректный номер телефона';
      } else {
        _phoneError = null; // Убираем ошибку, если телефон корректный
      }
    });

    // Проверяем, все ли поля корректны
    if (_emailError == null && _phoneError == null) {
      print('Логин: $_login');
      print('Пароль: $_password');
      print('Email: $_email');

      _phone = '8' + _phone.replaceAll(' ', '').replaceAll('-', '');
      print('Телефон: $_phone');

      try {
        String token = await registerUser(
          username: _login,
          password: _password,
          email: _email,
          phone: _phone,
        );

        _loginController.clear();
        _passwordController.clear();
        _emailController.clear();
        _phoneController.clear();

        setState(() {
          _isChecked = false;
        });

        await saveToken(token);
        print(await getToken());

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      } catch (e, stackTrace) {
        // Логирование ошибки для отладки
        print('Ошибка регистрации: $e');
        print('Stack trace: $stackTrace');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка регистрации. Повторите попытку.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      body: Center(
        child: SingleChildScrollView(
          // Оборачиваем в SingleChildScrollView для предотвращения переполнения
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(20.0), // Добавляем внутренние отступы
            constraints: const BoxConstraints(
              maxWidth: 400, // Максимальная ширина для адаптивности
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Минимальный размер по вертикали
              children: [
                const SizedBox(height: 20),
                // Поле для логина
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _loginController,
                    cursorRadius: const Radius.circular(30),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Имя пользователя",
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // Поле для пароля
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Colors.black,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // Поле для Email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _emailController,
                    cursorRadius: const Radius.circular(30),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                      errorText: _emailError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // Поле для телефона
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneFormatter(),
                    ],
                    cursorRadius: const Radius.circular(30),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Телефон",
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      errorText: _phoneError, // Отображение ошибки телефона
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      prefixText: '+7 ',
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // Галочка согласия
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CheckboxListTile(
                    value: _isChecked,
                    onChanged: _onChanged,
                    title: const Text(
                      'Я согласен на обработку персональных данных',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.yellow,
                    checkColor: Colors.black,
                  ),
                ),
                // Кнопка регистрации
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: _isChecked
                        ? () {
                            _onRegister();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,

                      ///onPrimary: Colors.black,
                      minimumSize: const Size(
                          double.infinity, 50), // Ширина кнопки по контейнеру
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Ссылка "Войти"
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Auth()),
                      );
                    }, // Замените на реальную навигацию
                    child: const Text(
                      'Войти',
                      style: TextStyle(
                        color: Colors.yellow,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.yellow,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

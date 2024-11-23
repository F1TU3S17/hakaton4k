import 'package:flutter/material.dart';
import 'package:hakaton4k/sreenes/pages/register.dart';
import 'package:hakaton4k/sreenes/mainScreen.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';

class CheckAuthWidget extends StatefulWidget {
  const CheckAuthWidget({super.key});

  @override
  State<CheckAuthWidget> createState() => _CheckAuthWidgetState();
}

class _CheckAuthWidgetState extends State<CheckAuthWidget> {
  bool? _isAuth; // null указывает на незавершённую проверку

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    ///await clearLocalStorage();
    final token = await getToken();
    setState(() {
      print(token);
      _isAuth = token != null;
 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuth == null) {
      // Показать экран загрузки пока идёт проверка
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Отобразить соответствующий экран после проверки
    return Scaffold(
      body: _isAuth! ? const MainScreen() : const Register(),
    );
  }
}

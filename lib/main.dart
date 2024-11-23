import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hakaton4k/sreenes/mainScreen.dart';
import 'package:hakaton4k/themes/appTheme.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/widgets/chekAuthWidget.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(const BudgetHelperApp());
}

class BudgetHelperApp extends StatelessWidget {
  const BudgetHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Финансовый помощник',
       localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Английский
        Locale('ru', ''), // Русский
      ],
      locale: const Locale('ru', ''), // Устанавливаем русский язык
      
      //home: const MainScreen(),
      //home: const Register(),
      
      home: CheckAuthWidget()
    );
  }
}

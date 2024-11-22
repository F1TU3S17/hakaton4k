import 'package:flutter/material.dart';
import 'package:hakaton4k/sreenes/pages/analiticPage.dart';
import 'package:hakaton4k/sreenes/pages/homePage.dart';
import 'package:hakaton4k/sreenes/pages/more.dart';
import 'package:hakaton4k/sreenes/pages/target.dart';
import 'package:hakaton4k/sreenes/pages/addNewTransaction.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  // Функция для изменения текущей страницы
  changeCurrentIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
    appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: const Text('Т-Аналитика', style: TextStyle(fontSize: 26))),
          ],
        ),
      ),
      bottomNavigationBar: appNavigationBar(),
      body: <Widget>[
        /// Главная страница
        HomePage(theme: theme),
        /// Страница аналитики
        AnaliticPage(),
        /// Cтраница добавления новой транзакции
        AddNewTransaction(theme: theme,),  
        /// Страница целей
        TargetPage(theme: theme),
        /// Страница ЕЩЕ
        MoreInfoPage(theme: theme),
       
      ][currentPageIndex],
    );
  }

  // Создаем навигационную панель с изменением внешнего вида кнопки "+"
  NavigationBar appNavigationBar() {
    return NavigationBar(
      onDestinationSelected: changeCurrentIndex,
      indicatorColor: Colors.yellow,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Главная',
        ),
        
        NavigationDestination(
          icon: Icon(Icons.analytics_sharp),
          label: 'Аналитика',
        ),
        // Кнопка "+" с желтым кружочком
        NavigationDestination(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow, // Желтый фон
            ),
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 30, // Размер иконки
            ),
          ),
          label: 'Добавить',
        ),
        NavigationDestination(
          icon: Icon(Icons.task_alt_rounded),
          label: 'Цели',
        ),
        NavigationDestination(
          icon: Icon(Icons.more), 
          label: 'Еще',
        )
      ],
    );
  }
}

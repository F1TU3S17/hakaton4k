import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:http/http.dart' as http;

class AppColors {
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class AnaliticPage extends StatefulWidget {
  const AnaliticPage({super.key});

  @override
  _AnaliticPageState createState() => _AnaliticPageState();
}

class _AnaliticPageState extends State<AnaliticPage> {
  DateTimeRange? _selectedDateRange;
  List<Map<String, dynamic>> _analyticsData = [];
  List<PieChartSectionData> _pieChartSections = [];
  bool _isLoading = true;
  bool _isExpenseView =
      true; // Флаг для переключения между расходами и доход/расходами
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();

    // Инициализируем диапазон дат текущего месяца
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    _selectedDateRange = DateTimeRange(
      start: firstDayOfMonth,
      end: lastDayOfMonth,
    );

    // Загружаем аналитические данные
    _fetchAnalyticsData(firstDayOfMonth, lastDayOfMonth);

    // Загружаем данные для диаграммы
    _fetchChartData();
  }

  // Заглушка для функции получения аналитических данных
  Future<void> _fetchAnalyticsData(DateTime start, DateTime end) async {
    // Эмуляция получения данных с сервера
    await Future.delayed(Duration(seconds: 1)); // Задержка
    try {
      setState(() {
        _analyticsData = [
          {
            'status': 0,
            'title': 'Высокая разница доходов и расходов',
            'info':
                'Ваши доходы существенно превышают расходы, что даёт вам почву для инвестиций.'
          },
          {
            'status': 1,
            'title': '10% вашего бюджета уходит на алкоголь',
            'info':
                'Очень много денег уходит на алкоголь. Если бы вы потратили хотя бы 5% от этой суммы на Инвест копилку, то заработали бы 321312 btc.'
          },
          {
            'status': 2,
            'title': 'Инвестиции в акции растут',
            'info':
                'Ваши инвестиции в акции показывают положительную динамику. Возможно, стоит увеличить долю в портфеле.'
          },
          {
            'status': 0,
            'title': 'Проблемы с кредитами',
            'info':
                'Ваши расходы на кредиты слишком высоки. Рассмотрите возможность рефинансирования.'
          },
        ];
      });
    } catch (ex) {}
  }

  // Заглушка для данных диаграммы
  Future<void> _fetchChartData() async {
    // Эмуляция запроса на сервер
    await Future.delayed(const Duration(seconds: 1)); // Эмуляция задержки
    final List<Map<String, dynamic>> dummyData = [
      {
        "id": "1",
        "type": "expense",
        "category": "food",
        "amount": 500,
        "date": "2024-11-23",
        "comment": "Покупка продуктов",
      },
      {
        "id": "2",
        "type": "expense",
        "category": "transport",
        "amount": 300,
        "date": "2024-11-22",
        "comment": "Бензин",
      },
      {
        "id": "3",
        "type": "expense",
        "category": "entertainment",
        "amount": 200,
        "date": "2024-11-21",
        "comment": "Кино",
      },
      {
        "id": "4",
        "type": "expense",
        "category": "bills",
        "amount": 1000,
        "date": "2024-11-20",
        "comment": "Квартплата",
      },
      {
        "id": "5",
        "type": "income",
        "category": "work",
        "amount": 60000,
        "date": "2024-11-20",
        "comment": "Зарплата",
      },
    ];

    // Преобразуем данные в формат для диаграммы
    _generateChartData(dummyData);
    try {
      setState(() {
        _isLoading = false; // Убираем индикатор загрузки
      });
    } catch (ex) {}
  }

  // Генерация данных для диаграммы из массива объектов
  void _generateChartData(List<Map<String, dynamic>> data) {
    Map<String, double> categoryExpenseMap = {};
    if (_isExpenseView) {
      // Проходим по всем данным и суммируем расходы или доходы по категориям
      for (var item in data) {
        if ((_isExpenseView && item['type'] == 'expense') ||
            (_isExpenseView && item['type'] != 'income')) {
          String category = item['category'];
          int amount = item['amount'];

          // Если категория уже существует, добавляем к сумме
          if (categoryExpenseMap.containsKey(category)) {
            categoryExpenseMap[category] =
                categoryExpenseMap[category]! + amount;
          } else {
            // Если категории нет, создаём новую запись
            categoryExpenseMap[category] = amount * 1.0;
          }
        }
      }

      // Преобразуем данные в формат для диаграммы
      List<PieChartSectionData> sections = [];
      categoryExpenseMap.forEach((category, amount) {
        sections.add(
          PieChartSectionData(
            value: amount,
            title: '${amount.toInt()}',
            color: _getCategoryColor(category), // Определяем цвет для категории
            radius: 40,
            titleStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      });

      try {
        setState(() {
          _pieChartSections = sections;
        });
      } catch (ex) {}
    } else {
      // Проходим по всем данным и суммируем расходы или доходы по категориям
      for (var item in data) {
        if ((!_isExpenseView && item['type'] == 'expense') ||
            (!_isExpenseView && item['type'] == 'income')) {
          String category = item['type'];
          int amount = item['amount'];

          // Если категория уже существует, добавляем к сумме
          if (categoryExpenseMap.containsKey(category)) {
            categoryExpenseMap[category] =
                categoryExpenseMap[category]! + amount;
          } else {
            // Если категории нет, создаём новую запись
            categoryExpenseMap[category] = amount * 1.0;
          }
        }
      }

      // Преобразуем данные в формат для диаграммы
      List<PieChartSectionData> sections = [];
      categoryExpenseMap.forEach((category, amount) {
        sections.add(
          PieChartSectionData(
            value: amount,
            title: '${amount.toInt()}',
            color: _getCategoryColor(category), // Определяем цвет для категории
            radius: 40,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      });

      try {
        setState(() {
          _pieChartSections = sections;
        });
      } catch (ex) {}
    }
  }

  // Функция для получения цвета для каждой категории
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'expense':
        return Colors.red;
      case 'income':
        return Colors.green;
      case 'food':
        return Colors.green;
      case 'transport':
        return Colors.blue;
      case 'entertainment':
        return Colors.purple;
      case 'bills':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Обработчик смены вида диаграммы
  void _toggleChartView() {
    setState(() {
      _isExpenseView = !_isExpenseView; // Переключаем флаг
    });
    _fetchChartData(); // Перезагружаем данные диаграммы с учётом нового типа
  }

  // Открытие выбора диапазона дат
  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.yellow,
              onPrimary: Colors.black,
              secondary: Colors.grey,
              onSecondary: Colors.black,
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.grey[900],
            dialogBackgroundColor: Colors.grey[850],
            dialogTheme: DialogTheme(backgroundColor: Colors.grey[850]),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: Colors.black)),
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[800],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.yellow, width: 2),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });

      // Вызываем функцию для получения аналитики с выбранными датами
      _fetchAnalyticsData(picked.start, picked.end);
    }
  }

  Future<List<FlSpot>> getListOfSpots(_selectedDateRange) async {
    var url =
        Uri.parse('https://test-go-babich.amvera.io/user/operations/period');
    // Получаем токен
    String? token = await getToken();
    token = token?.substring(10, token.length - 2);

    var headers = {
      'Authorization': /*'ApiKey $token'*/
          'ApiKey eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzI0NzQwNjEsImlhdCI6MTczMjM4NzY2MSwidXNlcl9pZCI6IjEifQ.AaDdeDue92ch1F4Aq0nJDfdKjzzxIMh74SherDZFmUI',
    };

    var body = jsonEncode({
      "start_date": _selectedDateRange.start.toString().substring(0, 10),
      "end_date": _selectedDateRange.end.toString().substring(0, 10),
    });

    print(url);
    print(body);
    print(headers);

    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print("писька");
    // Проверка статуса ответа
    if (response.statusCode == 200) {
      // Успешный ответ
      print('Response data: ${response.body}');
    } else {
      // Обработка ошибок
      print('Request failed with status: ${response.statusCode}');
    }
    List<FlSpot> listOfSpots = [];
    Map<int, int> mapOfSpots = {};
    if (response.body == "null") {
      return [];
    }
    var spots = jsonDecode(response.body);
    for (int i = 0; i < spots.length; i++) {
      if (spots[i]["date"] != null && spots[i]["amount"] != null) {
        DateTime spotDate = DateTime.parse(spots[i]["date"].toString());
        DateTime lowerTargetDate = _selectedDateRange.start;
        DateTime upperTargetDate = _selectedDateRange.end;
        int daysDifference = spotDate.difference(lowerTargetDate).inDays;
        print(daysDifference);
        int amount = int.parse(spots[i]["amount"].toString());
        print(amount);
        // if (spotDate.difference(upperTargetDate).inDays <= 0 ||
        //     spotDate.difference(lowerTargetDate).inDays < 0) {
        //   listOfSpots.add(FlSpot(daysDifference.toDouble(), amount.toDouble()));
        // }
        if (spots[i]["type"] == 0) {
          print("===");
          print(">>>");
          mapOfSpots[daysDifference] =
              (mapOfSpots[daysDifference] ?? 0) - amount;
        } else if (spots[i]["type"] == 1) {
          mapOfSpots[daysDifference] =
              (mapOfSpots[daysDifference] ?? 0) + amount;
        }
        print(spots[i]["type"]);
      }
    }
    mapOfSpots.forEach((key, value) {
      listOfSpots.add(FlSpot(key.toDouble(), value.toDouble()));
    });

    listOfSpots.sort((a, b) => a.x.compareTo(b.x));

    return listOfSpots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        title: const Text('Аналитика'),
      ),
      body: FutureBuilder<List<FlSpot>>(
        future:
            getListOfSpots(_selectedDateRange), // вызываем асинхронный метод
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("ожидаю...");
            return Center(
                child: CircularProgressIndicator()); // Пока данные загружаются
          }

          if (snapshot.hasError) {
            print("ОШИБКА ЕБАТЬ ТЕБЯ В СРАКУ");
            return Center(
                child: Text('Ошибка: ${snapshot.error}')); // Обработка ошибки
          }

          if (!snapshot.hasData) {
            print("ПУСТО EMPTY ЛОХ");
            return Center(child: Text('Нет данных')); // Если данных нет
          }

          List<FlSpot> spots = snapshot.data!;

          return SingleChildScrollView(
            // Оборачиваем весь контент
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  // Календарь для выбора диапазона дат
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateRange == null
                                ? 'Выберите диапазон дат'
                                : '${_selectedDateRange!.start.toLocal().toString().substring(0, 9)} - ${_selectedDateRange!.end.toLocal().toString().substring(0, 10)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Диаграмма
                  AspectRatio(
                    aspectRatio: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots, // Используем загруженные точки
                              isCurved: true,
                              curveSmoothness: 0.3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.yellow.withOpacity(0.3),
                              ),
                              color: Colors.yellow,
                            ),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  final matchingSpot = spots.firstWhere(
                                      (spot) => spot.x == value,
                                      orElse: () => FlSpot(0, 0));

                                  if (matchingSpot.x != 0) {
                                    Duration duration =
                                        Duration(days: matchingSpot.x.toInt());
                                    DateTime newDate =
                                        _selectedDateRange!.start.add(duration);
                                    String dateString =
                                        '${newDate.toString().substring(8, 10)}/${newDate.toString().substring(5, 7)}';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        dateString,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value < 1000 && value > -1000) {
                                    return Text(
                                      value.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    );
                                  } else {
                                    String newVal = value.toString();
                                    return Text(
                                      newVal.substring(0, newVal.length - 5) +
                                          'K',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Список аналитики
                  ListView.builder(
                    shrinkWrap: true, // Важно для корректного измерения высоты
                    physics:
                        const NeverScrollableScrollPhysics(), // Отключаем внутреннюю прокрутку
                    itemCount: _analyticsData.length,
                    itemBuilder: (context, index) {
                      var data = _analyticsData[index];
                      Color borderColor;

                      // Выбор цвета границы на основе статуса
                      switch (data['status']) {
                        case 0:
                          borderColor = Colors.red; // Отрицательная информация
                          break;
                        case 1:
                          borderColor = Colors.yellow; // Внимание
                          break;
                        case 2:
                          borderColor =
                              Colors.green; // Положительная информация
                          break;
                        default:
                          borderColor = Colors.grey;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: borderColor,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        data['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['info'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

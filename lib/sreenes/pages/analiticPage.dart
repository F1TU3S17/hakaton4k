import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/widgets/diagramsWidgets/DohodDiagramWidget.dart';
import 'package:hakaton4k/widgets/diagramsWidgets/OrerationsDiagramWidget.dart';
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
    // _fetchChartData();
  }

  // Заглушка для функции получения аналитических данных
  Future<void> _fetchAnalyticsData(DateTime start, DateTime end) async {
    // Эмуляция получения данных с сервера
    try {
      setState(() {
        _analyticsData = [
          {
            'status': 3,
            'title': 'Подсказка от нас!',
            'info':
                'Дополнительная экономия открывает дополнительные возможности!\nРеализуй свои сбережения с пользой!'
          },
          {
            'status': 0,
            'title': 'Высокая разница доходов и расходов',
            'info':
                'Ваши доходы существенно превышают расходы, что даёт вам почву для инвестиций.'
          },
          {
            'status': 1,
            'title': '10% вашего бюджета уходит на развлечения',
            'info':
                'Очень много денег уходит на развлечения. Если бы вы потратили хотя бы 5% от этой суммы на Инвест копилку, то заработали бы 321312 btc.'
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
      // ignore: empty_catches
    } catch (ex) {}
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
            colorScheme: const ColorScheme.light(
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
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[800],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.yellow, width: 2),
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
        //DateTime upperTargetDate = _selectedDateRange.end;
        int daysDifference = spotDate.difference(lowerTargetDate).inDays;
        int amount = int.parse(spots[i]["amount"].toString());
        // if (spotDate.difference(upperTargetDate).inDays <= 0 ||
        //     spotDate.difference(lowerTargetDate).inDays < 0) {
        //   listOfSpots.add(FlSpot(daysDifference.toDouble(), amount.toDouble()));
        // }
        if (spots[i]["type"] == 0) {
          mapOfSpots[daysDifference] =
              (mapOfSpots[daysDifference] ?? 0) - amount;
        } else if (spots[i]["type"] == 1) {
          mapOfSpots[daysDifference] =
              (mapOfSpots[daysDifference] ?? 0) + amount;
        }
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
      body: FutureBuilder<List<FlSpot>>(
        future:
            getListOfSpots(_selectedDateRange), // вызываем асинхронный метод
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("ожидаю...");
            return const Center(
                child: CircularProgressIndicator()); // Пока данные загружаются
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Ошибка: ${snapshot.error}')); // Обработка ошибки
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Нет данных')); // Если данных нет
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
                  DohodDiagramWidget(
                    selectedDateRange: _selectedDateRange,
                  ), // Передай диапазон дат),
                  const SizedBox(height: 20),
                  OperationsDiagramWidgets(
                    selectedDateRange: _selectedDateRange,
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
                      Color backgroundColor =
                          Theme.of(context).cardColor; // Цвет по умолчанию
                      TextStyle titleStyle =
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ) ??
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                              ); // Стиль по умолчанию
                      TextStyle infoStyle =
                          Theme.of(context).textTheme.bodySmall ??
                              const TextStyle();

                      bool isSpecialCard = data['status'] ==
                          3; // Проверяем, нужен ли спец. дизайн

                      // Выбор цвета границы и фона на основе статуса
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
                        case 3:
                          borderColor = Colors.green;
                          backgroundColor = Colors.yellow; // Жёлтый фон
                          titleStyle = titleStyle.copyWith(
                              color: Colors.black); // Чёрный текст
                          infoStyle = infoStyle.copyWith(
                              color: Colors.black); // Чёрный текст
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
                            color: backgroundColor, // Используем выбранный цвет
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
                                    if (isSpecialCard)
                                      CircleAvatar(
                                        radius: 22, // Радиус с учётом границы
                                        backgroundColor:
                                            Colors.black, // Цвет границы
                                        child: CircleAvatar(
                                          radius:
                                              20, // Радиус внутреннего изображения
                                          backgroundImage: AssetImage(
                                            'assets/logos/t.png',
                                          ),
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.circle,
                                        color: borderColor,
                                        size: 14,
                                      ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        data['title'],
                                        style:
                                            titleStyle, // Используем изменённый стиль
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['info'],
                                  style: infoStyle.copyWith(
                                    fontSize: isSpecialCard
                                        ? 16
                                        : infoStyle
                                            .fontSize, // Увеличиваем шрифт, если это особая карточка
                                  ),
                                ),
                                if (isSpecialCard) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      3,
                                      (index) => Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                index == 0
                                                    ? 'https://cdn.tbank.ru/static/pages/files/d39e9d26-fd5e-4574-9ad3-c3f2fc102598.png'
                                                    : index == 1
                                                        ? 'https://cdn.tbank.ru/static/pages/files/977ef771-1005-411e-a2db-64e8f92d5fb1.png'
                                                        : 'https://cdn.tbank.ru/static/pages/files/d819b1e8-293e-43b9-b28e-1f38f5058372.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Добавляем отступ между изображением и текстом
                                          Text(
                                            index == 0
                                                ? 'Т Банк'
                                                : index == 1
                                                    ? 'Т Бизнес'
                                                    : 'Т Инвестиции',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
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

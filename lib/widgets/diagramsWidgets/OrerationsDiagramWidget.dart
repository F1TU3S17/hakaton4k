import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:http/http.dart' as http;

class OperationsDiagramWidgets extends StatelessWidget {
  final DateTimeRange? selectedDateRange;

  OperationsDiagramWidgets({
    Key? key,
    required this.selectedDateRange,
  }) : super(key: key);

  // Список цветов для разных категорий
  final List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
  ];

  Future<Map<String, List<dynamic>>> getCategoryData(
      DateTimeRange? selectedDateRange) async {
    if (selectedDateRange == null) {
      return {};
    }

    var url =
        Uri.parse('https://test-go-babich.amvera.io/user/operations/period');
    String? token = await getToken();
    //token = token?.substring(10, token.length - 2);

    var headers = {
      'Authorization': 'ApiKey $token'
    };

    var body = jsonEncode({
      "start_date": selectedDateRange.start.toString().substring(0, 10),
      "end_date": selectedDateRange.end.toString().substring(0, 10),
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }

    Map<String, List<dynamic>> categoryData = {
      'barGroups': [],
      'categoryColorMapping': [],
    };

    Map<String, double> categoryMap = {}; // Мапа по категориям

    if (response.body == "null") {
      return categoryData;
    }

    var spots = jsonDecode(response.body);
    for (int i = 0; i < spots.length; i++) {
      if (spots[i]["category"] != null && spots[i]["amount"] != null) {
        String category = spots[i]["category"].toString();
        double amount = double.parse(spots[i]["amount"].toString());

        if (spots[i]["type"] == 0) {
          // Фильтруем по type 0
          categoryMap[category] = (categoryMap[category] ?? 0) + amount;
        }
      }
    }

    // Преобразование мапы в список баров для графика с разными цветами
    categoryMap.forEach((category, amount) {
      int categoryIndex =
          category.hashCode % colors.length; // Получаем индекс цвета

      // Добавляем в данные для графика
      categoryData['barGroups']?.add(
        BarChartGroupData(
          x: category.hashCode, // Используем hashCode категории как X-ось
          barRods: [
            BarChartRodData(
              toY: amount,
              color:
                  colors[categoryIndex], // Уникальный цвет для каждой категории
              width: 20, // Ширина столбика
              borderRadius: BorderRadius.zero, // Убираем закругления
            ),
          ],
        ),
      );

      // Добавляем в данные для легенды
      categoryData['categoryColorMapping']?.add(
        {'category': category, 'color': colors[categoryIndex]},
      );
    });

    return categoryData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<dynamic>>>(
      future: getCategoryData(selectedDateRange),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!['barGroups']!.isEmpty) {
          return const Center(child: Text('Нет данных'));
        }

        List<BarChartGroupData> barGroups =
            List<BarChartGroupData>.from(snapshot.data!['barGroups']!);
        List<dynamic> categoryColorMapping =
            snapshot.data!['categoryColorMapping']!;

        return AspectRatio(
          aspectRatio: 2.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups, // Используем группы баров
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // Убираем подписи на оси X
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
                                  '${newVal.substring(0, newVal.length - 5)}K',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                // Легенда
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categoryColorMapping.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: entry['color'],
                            ),
                            SizedBox(width: 5),
                            Text(entry['category'],
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

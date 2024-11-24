import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:http/http.dart' as http;

class DohodDiagramWidget extends StatelessWidget {
  final DateTimeRange? selectedDateRange;

  const DohodDiagramWidget({
    Key? key,
    required this.selectedDateRange,
  }) : super(key: key);

  Future<List<FlSpot>> getListOfSpots(DateTimeRange? selectedDateRange) async {
    if (selectedDateRange == null) {
      return [];
    }

    var url =
        Uri.parse('https://test-go-babich.amvera.io/user/operations/period');
    String? token = await getToken();
    print(token);
    //token = token?.substring(10, token.length - 2);


    var headers = {
      'Authorization': 'ApiKey $token',
    };

    var body = jsonEncode({
      "start_date": selectedDateRange.start.toString().substring(0, 10),
      "end_date": selectedDateRange.end.toString().substring(0, 10),
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Успешный ответ
      print('Response data: ${response.body}');
    } else {
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
        DateTime lowerTargetDate = selectedDateRange.start;
        int daysDifference = spotDate.difference(lowerTargetDate).inDays;
        int amount = int.parse(spots[i]["amount"].toString());

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
    return FutureBuilder<List<FlSpot>>(
      future: getListOfSpots(selectedDateRange),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Нет данных'));
        }

        List<FlSpot> spots = snapshot.data!;

        return AspectRatio(
          aspectRatio: 2.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots, // Используем загруженные точки
                    isCurved: true,
                    curveSmoothness: 0.3,
                    preventCurveOverShooting: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.yellow.withOpacity(0.3),
                    ),
                    color: Colors.yellow,
                  ),
                ],
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final matchingSpot = spots.firstWhere(
                            (spot) => spot.x == value,
                            orElse: () => const FlSpot(0, 0));

                        if (matchingSpot.x != 0) {
                          Duration duration =
                              Duration(days: matchingSpot.x.toInt());
                          DateTime newDate =
                              selectedDateRange!.start.add(duration);
                          String dateString =
                              '${newDate.toString().substring(8, 10)}/${newDate.toString().substring(5, 7)}';

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              dateString,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
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
                            '${newVal.substring(0, newVal.length - 5)}K',
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
        );
      },
    );
  }
}

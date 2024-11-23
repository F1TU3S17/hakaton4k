import 'package:flutter/material.dart';
import 'package:hakaton4k/modal/user.dart';
import 'package:hakaton4k/services/api/getUserInfo.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/widgets/homePageWidgees/balanceWidget.dart';
import 'package:hakaton4k/widgets/homePageWidgees/healthWidget.dart';
import 'package:hakaton4k/widgets/homePageWidgees/profileCard.dart';
import 'package:hakaton4k/widgets/homePageWidgees/transactionWidget.dart';
import '../../сonstants/transactions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.theme});

  final ThemeData theme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Метод для получения данных пользователя
  Future<User> _fetchUserData() async {
    try {
      final token = await getToken(); // Получение токена
      print(token);
      return (await fetchUser(token.toString()!))!; // Загрузка данных пользователя
    } catch (error) {
      throw Exception('Ошибка при загрузке данных: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        // Если данные еще загружаются, показываем индикатор загрузки
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Если произошла ошибка, показываем сообщение об ошибке
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ошибка: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Если данные загружены, показываем контент
        if (snapshot.hasData) {
          final userData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Карточка профиля
                profileCard(theme: widget.theme, user: userData),
                // Карточка баланса
                BalanceWidget(theme: widget.theme),
                // Карточка финансового здоровья
                HealthWidget(
                  theme: widget.theme,
                  healthScore: 0.98,
                ),
                // Карточка с транзакциями
                Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Последние транзакции',
                            style: widget.theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250, // Ограничение по высоте
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                return TransactionWidget(
                                  iconType: transaction['iconType'],
                                  categoryName: transaction['categoryName'],
                                  date: transaction['date'],
                                  cost: transaction['cost'],
                                  typeValue: transaction['typeValue'],
                                  isExpense: transaction['isExpense'],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0, // Убираем тень у кнопки
                                ),
                                onPressed: () {
                                  print('Все операции');
                                },
                                child: const Text('Детальнее'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // На случай, если данные отсутствуют
        return const Center(child: Text('Данные пользователя отсутствуют'));
      },
    );
  }
}

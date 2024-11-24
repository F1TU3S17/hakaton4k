import 'package:flutter/material.dart';
import 'package:hakaton4k/mapping/categories/allCategories.dart';
import 'package:hakaton4k/modal/user.dart';
import 'package:hakaton4k/services/api/getPeriodTransaction.dart';
import 'package:hakaton4k/services/api/getUserInfo.dart';
import 'package:hakaton4k/services/api/getUserAmount.dart';

import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/utils/calculateFinancialHealth.dart';
import 'package:hakaton4k/widgets/homePageWidgees/balanceWidget.dart';
import 'package:hakaton4k/widgets/homePageWidgees/healthWidget.dart';
import 'package:hakaton4k/widgets/homePageWidgees/profileCard.dart';
import 'package:hakaton4k/widgets/homePageWidgees/transactionWidget.dart';

import '../../utils/gettersFinParams.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.theme});

  final ThemeData theme;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _userAmount = 0;
  List<Map<String, dynamic>> _transactions = []; // Хранение транзакций

  // Метод для получения данных пользователя
  Future<User> _fetchUserData() async {
    try {
      final token = await getToken();
      _userAmount = await getBalance(token.toString());
      // Получение транзакций
      _transactions = await fetchTransactions(token.toString());
      _transactions.sort((a, b) => b['date'].compareTo(a['date']));
      return (await fetchUser(token.toString()))!;
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
                BalanceWidget(
                  theme: widget.theme,
                  amount: _userAmount,
                ),
                // Карточка финансового здоровья
                HealthWidget(
                  transactions: _transactions,
                  theme: widget.theme,
                  healthScore: calculateFinancialHealth(
                      getIncome(_transactions),
                      getExpenses(_transactions),
                      getInvestments(_transactions),
                      getDeposits(_transactions),
                      getFreeFunds(_transactions),
                      _userAmount.toDouble()),
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
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                final transaction = _transactions[index];
                                final categoryData =
                                    allCategories[transaction['category']];

                                return TransactionWidget(
                                  iconType: categoryData?['icon'] ??
                                      Icons
                                          .help_outline, // Иконка из маппинга или дефолтная
                                  categoryName: categoryData?['name'] ??
                                      'Неизвестная категория', // Название категории
                                  date: transaction['date'] ??
                                      'Неизвестная дата', // Дата транзакции
                                  cost: (transaction['amount'])
                                      .toString(), // Сумма
                                  typeValue: 'руб',
                                  isExpense: categoryData?['type'] ==
                                      1, // Определение, является ли транзакция расходом
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

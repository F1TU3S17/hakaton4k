import 'package:flutter/material.dart';
import 'package:hakaton4k/widgets/homePageWidgees/balanceWidget.dart';
import 'package:hakaton4k/widgets/homePageWidgees/profileCard.dart';
import 'package:hakaton4k/widgets/homePageWidgees/transactionWidget.dart';

import 'package:hakaton4k/widgets/homePageWidgees/healthWidget.dart'; // Импорт нового виджета

import '../../сonstants/transactions.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Карточка профиля
          profileCard(theme: theme),
          // Карточка баланса
          BalanceWidget(theme: theme),
          // Карточка финансового здоровья
          HealthWidget(
            theme: theme,
            healthScore: 0.99, 
          ),
          // Карточка с транзакциями
          Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Последние транзакции',
                      style: theme.textTheme.titleMedium?.copyWith(
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
                    Center(
                      child: ElevatedButton(
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
}

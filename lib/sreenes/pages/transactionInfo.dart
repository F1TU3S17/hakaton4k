import 'package:flutter/material.dart';

class TransactionInfo extends StatelessWidget {
  const TransactionInfo({
    super.key,
    required this.iconType,
    required this.categoryName,
    required this.date,
    required this.cost,
    required this.typeValue,
    required this.isExpense,
    required this.description,
  });
  final IconData iconType;
  final String categoryName;
  final String date;
  final String cost;
  final String typeValue;
  final bool isExpense;
  final String description;

  MaterialColor _transactionColor(bool isExpense) {
    return isExpense ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Возврат на предыдущую страницу
          },
        ),
        title: Text(date),
      ),
      body: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      categoryName,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    CircleAvatar(
                      backgroundColor: _transactionColor(isExpense),
                      child: Icon(
                        iconType,
                        size: 42,
                      ),
                      radius: 52,
                    ),
                    SizedBox(height: 16),
                    Text(
                      isExpense ? '+$cost $typeValue' : '-$cost $typeValue',
                      style: TextStyle(
                        color: _transactionColor(isExpense),
                        fontSize: 24,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тип: ${isExpense ? 'Доход' : 'Расход'}',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(
                          "Дата операции: $date",
                          style: theme.textTheme.labelLarge,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                "$description",
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

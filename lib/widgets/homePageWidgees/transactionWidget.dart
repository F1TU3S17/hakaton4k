import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    super.key,
    required this.iconType,
    required this.categoryName,
    required this.date,
    required this.cost,
    required this.typeValue,
    required this.isExpense,
  });

  final IconData iconType;
  final String categoryName;
  final String date;
  final String cost;
  final String typeValue;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Используем тему для оформления
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Иконка категории
          CircleAvatar(
            backgroundColor: isExpense ? Colors.green[100] : Colors.red[100],
            child: Icon(
              iconType,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          // Описание транзакции
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Стоимость и тип
          Text(
            '${isExpense ? '+' : '-'}$cost $typeValue',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isExpense ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

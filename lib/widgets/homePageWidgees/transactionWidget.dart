import 'package:flutter/material.dart';
import 'package:hakaton4k/sreenes/pages/transactionInfo.dart';

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
  final String description = "Какое-то описание операции, если бы оно приходило с бэка, эхх....";

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
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_rounded,
            ),
            onPressed: () => (
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionInfo(
                  iconType: iconType,
                  categoryName: categoryName,
                  date: date,
                  cost: cost,
                  typeValue: typeValue,
                  isExpense: isExpense,
                  description: description,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

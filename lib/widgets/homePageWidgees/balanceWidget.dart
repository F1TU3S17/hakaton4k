import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor, // Используем цвет из темы
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.yellow, // Желтый цвет из темы
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ваш Баланс',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white, // Белый текст для лучшего контраста
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              color: Colors.white.withOpacity(0.5), // Легкая белая линия
              thickness: 1,
            ),
            const SizedBox(height: 12),
            // Баланс
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12324.44 ₽', // Загружается текущий баланс
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white, // Белый для текста
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Кнопка без тени
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Фон кнопок
                foregroundColor: Colors.black, // Текст на кнопках
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Скругленные углы
                ),
                elevation: 0, // Убираем тень
              ),
              onPressed: () {
                print('Переход к транзакциям');
              },
              child: const Text('Подробнее'),
            ),
          ],
        ),
      ),
    );
  }
}

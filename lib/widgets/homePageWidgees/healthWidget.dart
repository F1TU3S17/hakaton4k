import 'package:flutter/material.dart';

class HealthWidget extends StatelessWidget {
  const HealthWidget({
    super.key,
    required this.theme,
    required this.healthScore,
  });

  final ThemeData theme;
  final double healthScore; // Значение от 0.0 до 1.0 (от красного к зеленому)

  @override
  Widget build(BuildContext context) {
    // Рассчитываем цвет на основе значения healthScore
    final color = Color.lerp(Colors.red, Colors.green, healthScore)!;

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
                Icon(
                  Icons.favorite,
                  color: Colors.red, // Цвет зависит от здоровья
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Финансовое здоровье',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white, // Белый текст для контраста
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
            // Индикатор здоровья
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        
                        value: healthScore, // От 0.0 до 1.0
                        strokeWidth: 8.0,
                        valueColor: AlwaysStoppedAnimation(color),
                        backgroundColor: Colors.grey[300],
                      ),
                      Text(
                        '${(healthScore * 100).toInt()}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ваш показатель здоровья: ${(healthScore * 100).toInt()}%. Следите за расходами.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Кнопка без тени
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Фон кнопки
                foregroundColor: Colors.black, // Текст на кнопке
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Скругленные углы
                ),
                elevation: 0, // Убираем тень
              ),
              onPressed: () {
                print('Переход к деталям здоровья');
              },
              child: const Text('Подробнее'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

final pi = 3.14;

class HealthWidget extends StatefulWidget {
  const HealthWidget({
    super.key,
    required this.theme,
    required this.healthScore,
  });

  final ThemeData theme;
  final double healthScore; // Значение от 0.0 до 1.0 (от красного к зеленому)

  @override
  _HealthWidgetState createState() => _HealthWidgetState();
}

class _HealthWidgetState extends State<HealthWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.healthScore,
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: getHealthColor(0.0),
      end: getHealthColor(widget.healthScore),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Метод для определения цвета в зависимости от healthScore
  Color getHealthColor(double score) {
    if (score < 0.4) {
      return Colors.red;
    } else if (score < 0.7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

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
          color: widget.theme.cardColor, // Используем цвет из темы
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
                  color: getHealthColor(widget.healthScore), // Цвет зависит от здоровья
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Финансовое здоровье',
                  style: widget.theme.textTheme.titleMedium?.copyWith(
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
                  width: 120,
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ProgressPainter(
                          progress: _animation.value,
                          color: _colorAnimation.value!,
                          backgroundColor: Colors.grey[300]!,
                        ),
                        child: Center(
                          child: Text(
                            '${(_animation.value * 100).toInt()}%',
                            style: widget.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _colorAnimation.value,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Следите не только за физичиским здоровьем, но и за финансовым.',
                    style: widget.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
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

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  ProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10; // Уменьшаем радиус, чтобы линия не выходила за пределы
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0; // Увеличиваем толщину линии

    // Рисуем фон
    paint.color = backgroundColor;
    canvas.drawCircle(center, radius, paint);

    // Рисуем прогресс
    paint.color = color;
    final sweepAngle = 360 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Начинаем с верхней точки
      degreesToRadians(sweepAngle),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

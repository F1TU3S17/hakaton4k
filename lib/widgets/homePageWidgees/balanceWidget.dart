import 'package:flutter/material.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({
    super.key,
    required this.theme,
    required this.amount,
  });

  final int amount;
  final ThemeData theme;

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  bool _showDetails = false; // Флаг для переключения состояния

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
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1), // Начальная позиция (чуть ниже)
                end: Offset.zero, // Конечная позиция
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showDetails ? _buildDetails(context) : _buildOverview(context),
        ),
      ),
    );
  }

  // Основной контент (начальный экран)
  Widget _buildOverview(BuildContext context) {
    return Column(
      key: const ValueKey('overview'), // Ключ для AnimatedSwitcher
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Заголовок
        Row(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.yellow,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              'Ваш Баланс',
              style: widget.theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Баланс
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.amount} ₽',
              style: widget.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Кнопка перехода
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () {
            setState(() {
              _showDetails = true; // Переключаемся на детали
            });
          },
          child: const Text('Подробнее'),
        ),
      ],
    );
  }

  // Детальный контент
  Widget _buildDetails(BuildContext context) {
    return Column(
      key: const ValueKey('details'), // Ключ для AnimatedSwitcher
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Заголовок
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.yellow,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              'Детали счета',
              style: widget.theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Информация с иконками
        Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.yellow, size: 24),
            const SizedBox(width: 8),
            Text(
              'Баланс: ${widget.amount} ₽',
              style: widget.theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.security, color: Colors.yellow, size: 24),
            const SizedBox(width: 8),
            Text(
              'Все транзакции защищены.',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Кнопка назад
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () {
            setState(() {
              _showDetails = false; // Вернуться на начальный экран
            });
          },
          child: const Text('Назад'),
        ),
      ],
    );
  }
}

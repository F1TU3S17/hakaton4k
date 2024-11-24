import 'package:flutter/material.dart';

class FinancialHealthDetailScreen extends StatelessWidget {
  const FinancialHealthDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансовое здоровье'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white, // Белый текст на AppBar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            context,
            title: 'Доходы',
            icon: Icons.attach_money,
            description: 'Ваш общий доход составляет 50 000 рублей.',
            recommendation: 'Рассмотрите возможность открытия накопительного счета для получения процентов на остаток.',
            productName: 'Накопительный счет',
            onPressed: () {
              print('Подробнее о доходах и накопительном счете');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Расходы',
            icon: Icons.money_off,
            description: 'Ваши общие расходы составляют 30 000 рублей.',
            recommendation: 'Используйте кредитную карту с кешбэком для экономии на повседневных покупках.',
            productName: 'Кредитная карта с кешбэком',
            onPressed: () {
              print('Подробнее о расходах и кредитной карте с кешбэком');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Сбережения',
            icon: Icons.savings,
            description: 'Ваши общие сбережения составляют 10 000 рублей.',
            recommendation: 'Инвестируйте свои сбережения в ПИФы для получения дополнительного дохода.',
            productName: 'ПИФы',
            onPressed: () {
              print('Подробнее о сбережениях и ПИФах');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Долги',
            icon: Icons.credit_card,
            description: 'Ваши общие долги составляют 5 000 рублей.',
            recommendation: 'Рефинансируйте свои долги с помощью кредита под более низкий процент.',
            productName: 'Рефинансирование кредитов',
            onPressed: () {
              print('Подробнее о долгах и рефинансировании');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Инвестиции',
            icon: Icons.trending_up,
            description: 'Ваши общие инвестиции составляют 15 000 рублей.',
            recommendation: 'Рассмотрите возможность диверсификации ваших инвестиций с помощью брокерского счета.',
            productName: 'Брокерский счет',
            onPressed: () {
              print('Подробнее об инвестициях и брокерском счете');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Бюджетирование',
            icon: Icons.account_balance_wallet,
            description: 'Ваше соотношение доходов и расходов составляет 70%.',
            recommendation: 'Используйте мобильное приложение Т-Банка для автоматизации бюджетирования.',
            productName: 'Мобильное приложение Т-Банка',
            onPressed: () {
              print('Подробнее о мобильном приложении');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'Финансовые цели',
            icon: Icons.flag,
            description: 'Вы достигли 80% своих финансовых целей.',
            recommendation: 'Установите новые финансовые цели и используйте финансовый план от Т-Банка для их достижения.',
            productName: 'Финансовый план',
            onPressed: () {
              print('Подробнее о финансовых целях и финансовом плане');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required String recommendation,
    required String productName,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.grey[800], // Черный цвет с прозрачностью
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.yellow),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Белый текст
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white, // Белый текст
                  ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Рекомендация: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.yellow, // Желтый текст для "Рекомендация"
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  TextSpan(
                    text: recommendation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white, // Белый текст для рекомендации
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: onPressed,
              child: Text('Подробнее'), // Уменьшенный текст в кнопке
            ),
          ],
        ),
      ),
    );
  }
}
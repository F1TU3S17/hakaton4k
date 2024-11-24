import 'package:flutter/material.dart';
import 'package:hakaton4k/services/api/getUserAmount.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';
import 'package:hakaton4k/utils/gettersFinParams.dart';
import 'package:hakaton4k/utils/normalizers.dart';

class FinancialHealthDetailScreen extends StatefulWidget {
  const FinancialHealthDetailScreen({super.key, required this.transactions});
  final List<Map<String, dynamic>> transactions;

  @override
  _FinancialHealthDetailScreenState createState() => _FinancialHealthDetailScreenState();
}

class _FinancialHealthDetailScreenState extends State<FinancialHealthDetailScreen> {
  late double balance;

  @override
  void initState() {
    super.initState();
    _getBalance();
  }

  // Получаем баланс асинхронно
  Future<void> _getBalance() async {
    final token = await getToken();
    balance = await getBalance(token!);
    setState(() {}); // После получения баланса обновляем UI
  }

  @override
  Widget build(BuildContext context) {
    // Показать загрузку, пока баланс не получен
    if (balance == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Финансовое здоровье'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансовое здоровье'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FinancialHealthCard(
            title: 'Доходы',
            icon: Icons.attach_money,
            amount: getIncome(widget.transactions),
            normalizedValue: normalizeIncome(getIncome(widget.transactions)),
            description: 'Ваш общий доход составляет ${getIncome(widget.transactions)} рублей.',
            lowRecommendation: 'Ваш доход ниже среднего. Рассмотрите возможность увеличения доходов.',
            mediumRecommendation: 'Ваш доход на среднем уровне. Оптимизируйте расходы.',
            highRecommendation: 'Ваш доход выше среднего. Продолжайте в том же духе!',
            onPressed: () {
              print('Подробнее о доходах и накопительном счете');
            },
          ),
          const SizedBox(height: 16),
          FinancialHealthCard(
            title: 'Расходы',
            icon: Icons.money_off,
            amount: getExpenses(widget.transactions),
            normalizedValue: normalizeExpenses(getExpenses(widget.transactions), getIncome(widget.transactions)),
            description: 'Ваши общие расходы составляют ${getExpenses(widget.transactions)} рублей.',
            lowRecommendation: 'Попробуйте уменьшить расходы для улучшения финансовой стабильности.',
            mediumRecommendation: 'Ваши расходы в пределах нормы. Продолжайте отслеживать бюджет.',
            highRecommendation: 'Отличное управление расходами! Вы на правильном пути.',
            onPressed: () {
              print('Подробнее о расходах');
            },
          ),
          const SizedBox(height: 16),
          FinancialHealthCard(
            title: 'Инвестиции',
            icon: Icons.trending_up,
            amount: getInvestments(widget.transactions),
            normalizedValue: normalizeInvestments(getInvestments(widget.transactions), balance),
            description: 'Ваши инвестиции составляют ${getInvestments(widget.transactions)} рублей.',
            lowRecommendation: 'Попробуйте выделить больше средств на инвестиции.',
            mediumRecommendation: 'Вы вкладываете на нормальном уровне. Рассмотрите диверсификацию.',
            highRecommendation: 'Ваши инвестиции на отличном уровне! Так держать.',
            onPressed: () {
              print('Подробнее об инвестициях');
            },
          ),
          const SizedBox(height: 16),
          FinancialHealthCard(
            title: 'Вклады',
            icon: Icons.savings,
            amount: getDeposits(widget.transactions),
            normalizedValue: normalizeDeposits(getDeposits(widget.transactions), balance),
            description: 'Ваши вклады составляют ${getDeposits(widget.transactions)} рублей.',
            lowRecommendation: 'Попробуйте выделить больше средств на накопительные вклады.',
            mediumRecommendation: 'Ваши вклады в норме. Рассмотрите увеличение доли вкладов.',
            highRecommendation: 'Ваши накопления на отличном уровне!',
            onPressed: () {
              print('Подробнее о вкладах');
            },
          ),
          const SizedBox(height: 16),
          FinancialHealthCard(
            title: 'Свободные средства',
            icon: Icons.wallet,
            amount: getFreeFunds(widget.transactions),
            normalizedValue: normalizeFreeFunds(getFreeFunds(widget.transactions)),
            description: 'Ваши свободные средства составляют ${getFreeFunds(widget.transactions)} рублей.',
            lowRecommendation: 'Попробуйте выделить больше средств на свободные расходы.',
            mediumRecommendation: 'Ваши свободные средства в пределах нормы.',
            highRecommendation: 'У вас достаточно свободных средств для финансовой гибкости.',
            onPressed: () {
              print('Подробнее как потратить свободные средства');
            },
          ),
        ],
      ),
    );
  }
}

class FinancialHealthCard extends StatelessWidget {
  const FinancialHealthCard({
    super.key,
    required this.title,
    required this.icon,
    required this.amount,
    required this.normalizedValue,
    required this.description,
    required this.lowRecommendation,
    required this.mediumRecommendation,
    required this.highRecommendation,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final double amount;
  final double normalizedValue;
  final String description;
  final String lowRecommendation;
  final String mediumRecommendation;
  final String highRecommendation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = normalizedValue < 0.5
        ? Colors.red
        : (normalizedValue < 0.7 ? Colors.yellow : Colors.green);

    final String recommendation = normalizedValue < 0.5
        ? lowRecommendation
        : (normalizedValue < 0.7 ? mediumRecommendation : highRecommendation);

    return Card(
      color: cardColor,
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
                Icon(icon, size: 32, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Рекомендация: $recommendation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
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
              child: Text('Подробнее о $title'),
            ),
          ],
        ),
      ),
    );
  }
}

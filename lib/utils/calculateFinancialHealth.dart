import 'package:hakaton4k/utils/normalizers.dart';

double calculateFinancialHealth(
  double income,
  double expenses,
  double investments,
  double deposits,
  double freeFunds,
  double balance,
) {
  // Веса для каждого показателя (сумма должна быть равна 1)
  const double incomeWeight = 0.30; // Увеличить вес дохода
  const double expensesWeight = 0.20; // Уменьшить вес расходов
  const double investmentsWeight = 0.20;
  const double depositsWeight = 0.20;
  const double freeFundsWeight = 0.10;

  // Нормализация показателей
  double normalizedIncome = normalizeIncome(income);
  double normalizedExpenses = normalizeExpenses(expenses, income);
  double normalizedInvestments = normalizeInvestments(investments, balance);
  double normalizedDeposits = normalizeDeposits(deposits, balance);
  double normalizedFreeFunds = normalizeFreeFunds(freeFunds);

  print('Вычисление фин здоровья');
  // print(income);
  // print(expenses);
  // print(investments);
  // print(deposits);
  // print(freeFunds);


  // print(normalizedIncome);
  // print(normalizedExpenses);
  // print(normalizedInvestments);
  // print(normalizedDeposits);
  // print(normalizedFreeFunds);
  

  // Расчет финансового здоровья
  double financialHealth = (normalizedIncome * incomeWeight) +
      (normalizedExpenses * expensesWeight) +
      (normalizedInvestments * investmentsWeight) +
      (normalizedDeposits * depositsWeight) +
      (normalizedFreeFunds * freeFundsWeight);

  return financialHealth;
}


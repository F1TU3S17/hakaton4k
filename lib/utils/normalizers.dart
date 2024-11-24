double normalizeIncome(double income) {
  const double averageIncome = 50000; // Средний доход
  const double maxIncome = 200000;   // Максимальный доход

  if (income <= averageIncome) {
    return income / averageIncome; // Линейная нормализация для доходов ниже среднего
  } else if (income <= maxIncome) {
    return 0.5 + (income - averageIncome) / (2 * (maxIncome - averageIncome)); 
    // Промежуточные значения между 0.5 и 1.0
  } else {
    return 1.0; // Все отлично, доход выше максимального
  }
}

double normalizeExpenses(double expenses, double income) {
  const double minExpenses = 10000;  // Минимальные расходы
  double maxExpenses = income; // Максимальные приемлемые расходы

  if (expenses <= minExpenses) {
    return 1.0; // Идеальные расходы
  } else if (expenses <= maxExpenses) {
    return 1.0 - (expenses - minExpenses) / (maxExpenses - minExpenses); 
    // Линейное снижение от 1.0 до 0.0
  } else {
    return 0.0; // Расходы выше нормы
  }
}

double normalizeInvestments(double investments,  double balance) {
  //const double balance = 100000; // Баланс для расчетов
  const double minInvestmentPercentage = 0.10; // Минимальный порог инвестиций
  const double maxInvestmentPercentage = 0.50; // Максимальный порог инвестиций

  double investmentPercentage = investments / balance;

  if (investmentPercentage <= minInvestmentPercentage) {
    return investmentPercentage / minInvestmentPercentage; // Линейная нормализация
  } else if (investmentPercentage <= maxInvestmentPercentage) {
    return 1.0; // Идеальный диапазон
  } else {
    return 0.8 + 0.2 * (1 - (investmentPercentage - maxInvestmentPercentage)); 
    // Немного выше нормы, не критично
  }
}

double normalizeDeposits(double deposits, double balance) {
  //const double balance = 100000; // Баланс для расчетов
  const double minDepositPercentage = 0.10; // Минимальный порог вкладов
  const double maxDepositPercentage = 0.50; // Максимальный порог вкладов

  double depositPercentage = deposits / balance;

  if (depositPercentage <= minDepositPercentage) {
    return depositPercentage / minDepositPercentage; // Линейная нормализация
  } else if (depositPercentage <= maxDepositPercentage) {
    return 1.0; // Идеальные вклады
  } else {
    return 0.8 + 0.2 * (1 - (depositPercentage - maxDepositPercentage)); 
    // Немного выше нормы
  }
}

double normalizeFreeFunds(double freeFunds) {
  const double balance = 100000; // Баланс для расчетов
  const double minFreeFundsPercentage = 0.10; // Минимальный порог свободных средств
  const double maxFreeFundsPercentage = 0.50; // Максимальный порог свободных средств

  double freeFundsPercentage = freeFunds / balance;

  if (freeFundsPercentage <= minFreeFundsPercentage) {
    return freeFundsPercentage / minFreeFundsPercentage; // Линейная нормализация
  } else if (freeFundsPercentage <= maxFreeFundsPercentage) {
    return 1.0; // Идеальные свободные средства
  } else {
    return 0.9; // Максимально безопасный уровень
  }
}

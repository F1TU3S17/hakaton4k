double getIncome(List<Map<String, dynamic>> transactions) {
    return transactions
        .where((transaction) => transaction['type'] == 1)
        .fold(0, (sum, transaction) => sum + transaction['amount']);
  }

  double getExpenses(List<Map<String, dynamic>> transactions) {
    return transactions
        .where((transaction) => transaction['type'] == 0)
        .fold(0, (sum, transaction) => sum + transaction['amount']);
  }

  double getInvestments(List<Map<String, dynamic>> transactions) {
    return transactions
        .where((transaction) => transaction['category'] == '12415')
        .fold(0, (sum, transaction) => sum + transaction['amount']);
  }

  double getDeposits(List<Map<String, dynamic>> transactions) {
    return transactions
        .where((transaction) => transaction['category'] == '12417')
        .fold(0, (sum, transaction) => sum + transaction['amount']);
  }

  double getFreeFunds(List<Map<String, dynamic>> transactions) {
    return getIncome(transactions) - getExpenses(transactions);
  }
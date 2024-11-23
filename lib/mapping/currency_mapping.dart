import 'package:flutter/material.dart';

// Маппинг валют
const Map<String, Icon> currencyMapping = {
  'RUB': Icon(Icons.currency_ruble, color: Colors.green), // Рубль
  'USD': Icon(Icons.attach_money, color: Colors.green),  // Доллар
  'EUR': Icon(Icons.euro, color: Colors.green),          // Евро
  'GBP': Icon(Icons.currency_pound, color: Colors.green), // Фунт
  'JPY': Icon(Icons.currency_yen, color: Colors.green),  // Йена
  'CNY': Icon(Icons.currency_exchange, color: Colors.green), // Юань
  'INR': Icon(Icons.currency_rupee, color: Colors.green), // Рупия
  'CAD': Icon(Icons.currency_bitcoin, color: Colors.green), // Канадский доллар
  'AUD': Icon(Icons.currency_exchange, color: Colors.green), // Австралийский доллар
  'CHF': Icon(Icons.currency_exchange, color: Colors.green), // Швейцарский франк
};

import 'package:flutter/material.dart';

// Маппинг категорий доходов с уникальными id
final Map<String, Map<String, dynamic>> incomeCategories = {
  'salary': {
    'category': '12412',
    'icon': Icons.attach_money,
    'name': 'Зарплата'
  },
  'gifts': {
    'category': '12413',
    'icon': Icons.card_giftcard,
    'name': 'Подарки'
  },
  'freelance': {
    'category': '12414',
    'icon': Icons.work,
    'name': 'Фриланс'
  },
  'investments': {
    'category': '12415',
    'icon': Icons.trending_up,
    'name': 'Инвестиции'
  },
  'bonus': {
    'category': '12416',
    'icon': Icons.star_border_purple500_rounded,
    'name': 'Стипендия'
  },
};
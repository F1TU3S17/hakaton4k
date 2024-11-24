import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> allCategories = {
  // Категории расходов
  '22412': {
    'icon': Icons.fastfood,
    'name': 'Еда',
    'type': 0, // Расход
  },
  '22413': {
    'icon': Icons.directions_car,
    'name': 'Транспорт',
    'type': 0, // Расход
  },
  '22414': {
    'icon': Icons.movie,
    'name': 'Развлечения',
    'type': 0, // Расход
  },
  '22415': {
    'icon': Icons.house,
    'name': 'Жилищные расходы',
    'type': 0, // Расход
  },
  '22416': {
    'icon': Icons.health_and_safety,
    'name': 'Здоровье',
    'type': 0, // Расход
  },
  '100': {
    'icon': Icons.qr_code_2,
    'name': 'С Qr-кода',
    'type': 0, // Расход
  },

  // Категории доходов
  '12412': {
    'icon': Icons.attach_money,
    'name': 'Зарплата',
    'type': 1, // Доход
  },
  '12413': {
    'icon': Icons.card_giftcard,
    'name': 'Подарки',
    'type': 1, // Доход
  },
  '12414': {
    'icon': Icons.work,
    'name': 'Фриланс',
    'type': 1, // Доход
  },
  '12415': {
    'icon': Icons.trending_up,
    'name': 'Инвестиции',
    'type': 1, // Доход
  },
  '12416': {
    'icon': Icons.star_border_purple500_rounded,
    'name': 'Стипендия',
    'type': 1, // Доход
  },
  '12417': {
    'icon': Icons.cases_sharp,
    'name': 'Вклады',
    'type': 1,
  },
};

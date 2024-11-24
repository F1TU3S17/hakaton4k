import 'package:flutter/material.dart';

// Модель для обработки данных
class Transaction {
  final int type; // Тип транзакции (1 — доход, 2 — расход)
  final String category; // ID категории (например, '12412')
  final String date; // Дата транзакции
  final int amount; // Сумма транзакции
  final String comment; // Комментарий к транзакции

  // Конструктор
  Transaction({
    required this.type,
    required this.category,
    required this.date,
    required this.amount,
    required this.comment,
  });

  // Метод для создания экземпляра из JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      category: json['category'],
      date: json['date'],
      amount: json['amount'],
      comment: json['comment'],
    );
  }

  // Метод для преобразования модели в JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'date': date,
      'amount': amount,
      'comment': comment,
    };
  }
}

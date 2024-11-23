import 'package:flutter/material.dart';
import 'package:hakaton4k/mapping/categories/expenseCategories.dart';
import 'package:hakaton4k/mapping/categories/incomeCategories.dart';
import 'package:hakaton4k/mapping/currency_mapping.dart';

class AddNewTransaction extends StatefulWidget {
  const AddNewTransaction({super.key, required this.theme});

  final ThemeData theme;

  @override
  State<AddNewTransaction> createState() => _AddNewTransactionState();
}

class _AddNewTransactionState extends State<AddNewTransaction> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String _selectedCurrency = 'RUB'; // Валюта по умолчанию
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;
  final TextEditingController _amountController = TextEditingController();

  String _dateToString() {
    String answer;
    answer =
        _selectedDate.toLocal().toString().split(' ')[0].replaceAll('-', '.');
    return answer;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Сумма: ${_amountController.text}');
      print('Категория: $_category');
      print('Дата: $_selectedDate');
      print('Тип: ${_isExpense ? "Расход" : "Доход"}');
      print('Валюта: $_selectedCurrency');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить транзакцию'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Поле ввода суммы
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Сумма',
                            prefixIcon: Icon(Icons.monetization_on,
                                color: Colors.yellowAccent),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите сумму';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Введите корректное число';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Выбор валюты
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Валюта',
                            prefixIcon: Icon(Icons.currency_exchange,
                                color: Colors.yellowAccent),
                          ),
                          value: _selectedCurrency,
                          items: currencyMapping.keys
                              .map((code) => DropdownMenuItem(
                                    value: code,
                                    child: Row(
                                      children: [
                                        currencyMapping[code]!,
                                        const SizedBox(width: 8),
                                        Text(code),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Выберите валюту';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Выбор типа транзакции
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpense = true;
                                    _category = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isExpense
                                      ? Colors.yellow
                                      : Colors.yellow.withOpacity(0.5),
                                ),
                                child: const Text(
                                  'Расход',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpense = false;
                                    _category = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_isExpense
                                      ? Colors.yellow
                                      : Colors.yellow.withOpacity(0.5),
                                ),
                                child: const Text(
                                  'Доход',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Выбор категории
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText:
                                'Категория ${_isExpense ? "расходов" : "доходов"}',
                            prefixIcon: const Icon(Icons.create,
                                color: Colors.yellowAccent),
                          ),
                          value: _category,
                          items: (_isExpense
                                  ? expenseCategories
                                  : incomeCategories)
                              .entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Icon(entry.value,
                                          color: Colors.yellowAccent),
                                      const SizedBox(width: 8),
                                      Text(entry.key),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Выберите категорию';
                            }
                            return null;
                          },
                        ),

                        // Выбор даты
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('${_dateToString()}'),
                        ),
                        const SizedBox(height: 16),
                        // Кнопка сохранения
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Сохранить'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

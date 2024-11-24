import 'package:flutter/material.dart';
import 'package:hakaton4k/mapping/categories/expenseCategories.dart';
import 'package:hakaton4k/mapping/categories/incomeCategories.dart';
import 'package:hakaton4k/mapping/currency_mapping.dart';
import 'package:hakaton4k/modal/transaction.dart';
import 'package:hakaton4k/services/api/addTransaction.dart';
import 'package:hakaton4k/services/localStorage/ls.dart';

class AddNewTransaction extends StatefulWidget {
  const AddNewTransaction({super.key, required this.theme});

  final ThemeData theme;

  @override
  State<AddNewTransaction> createState() => _AddNewTransactionState();
}

class _AddNewTransactionState extends State<AddNewTransaction>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String _selectedCurrency = 'RUB'; // Валюта по умолчанию
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController(); // Контроллер для дополнительной информации

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = false;
  bool _isSuccess = false;

  String _dateToString() {
    String answer;
    answer =
        _selectedDate.toLocal().toString().split(' ')[0].replaceAll('-', '.');
    return answer;
  }

  void _submitForm() async {
    final token = await getToken();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? categoryId = (_isExpense
          ? expenseCategories
          : incomeCategories)[_category]?['category'];

      bool f = await postTransaction(
        Transaction(
          amount: int.parse(_amountController.text),
          category: categoryId!,
          date: _dateToString().replaceAll('.', '-'),
          type: _isExpense ? 0 : 1,
          comment: _additionalInfoController.text,
        ),
        token!,
      );

      setState(() {
        _isLoading = false;
        _isSuccess = f;
      });

      if (_isSuccess) {
        _animationController.forward();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isSuccess = false;
          });
        });
      }
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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить транзакцию'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                          if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
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
                                    Icon(entry.value['icon'],
                                        color: Colors.yellowAccent),
                                    const SizedBox(width: 8),
                                    Text(entry.value['name']),
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

                      // Поле для дополнительной информации
                      Container(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0), // Паддинг для выравнивания
                        child: Row(
                          children: [
                            Icon(
                              Icons.comment,
                              color: Colors.yellowAccent,
                              size: 24.0, // Размер иконки
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _additionalInfoController,
                                decoration: InputDecoration(
                                  labelText: 'Дополнительная информация',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                maxLines: 3, // Многострочное поле
                                validator: (value) {
                                  return null; // Здесь можно добавить валидацию, если нужно
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('${_dateToString()}'),
                      ),
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
      ),
      floatingActionButton: _isLoading || _isSuccess
          ? Container(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow, // Желтый фон
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              value: _rotationAnimation.value,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black), // Черный кружочек
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.black, // Черная галочка
                              size: 48,
                            ),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }
}
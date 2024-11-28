import 'package:flutter/material.dart';
import 'package:hakaton4k/mapping/categories/allCategories.dart';
import 'package:hakaton4k/widgets/homePageWidgees/transactionWidget.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({
    super.key,
    required this.transactions,
    required this.theme,
  });
  final List<Map<String, dynamic>> transactions;
 
  final theme;
  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  
  List<Map<String, dynamic>> items = [
    {'name': 'Доходы', 'isChecked': true},
    {'name': 'Расходы', 'isChecked': true},
  ];
  
  void _toggleCheckbox(int index) {
    setState(() {
      items[index]['isChecked'] = !(items[index]['isChecked']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Все транзакции'),
      ),
      body: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //SizedBox(height: 200, child: CheckboxList()),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = widget.transactions[index];
                      final categoryData =
                          allCategories[transaction['category']];
                      return TransactionWidget(
                        iconType: categoryData?['icon'] ??
                            Icons
                                .help_outline, // Иконка из маппинга или дефолтная
                        categoryName: categoryData?['name'] ??
                            'Неизвестная категория', // Название категории
                        date: transaction['date'] ??
                            'Неизвестная дата', // Дата транзакции
                        cost: (transaction['amount']).toString(), // Сумма
                        typeValue: '₽',
                        isExpense: categoryData?['type'] ==
                            1, // Определение, является ли транзакция расходом
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    child: Text('Настройки'),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 100,
                                  child: CheckboxList(
                                    items: items, 
                                    onChanged: _toggleCheckbox,),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckboxList extends StatefulWidget {
  const CheckboxList({required this.items, required this.onChanged});
  final List<Map<String, dynamic>> items;
  final Function onChanged;
  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  _ListState(){
    setState(() {
      });
    }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(widget.items[index]['name']),
          value: widget.items[index]['isChecked'],
          onChanged: (bool? value) {widget.onChanged(index);_ListState();},
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  final Function(double) onUpdateExpensesTotal;

  ExpensePage({required this.onUpdateExpensesTotal});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  double expenseAmount = 0.0;
  final List<Map<String, dynamic>> transactions = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _addExpense() {
    if (expenseAmount > 0) {
      setState(() {
        transactions.add({
          'amount': expenseAmount,
          'date': DateTime.now(),
          'category': _categoryController.text,
        });
        widget.onUpdateExpensesTotal(transactions.fold<double>(
            0, (previousValue, transaction) => previousValue + transaction['amount']));
        _amountController.clear();
        _categoryController.clear();
      });
    }
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  expenseAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Add"),
              onPressed: () {
                _addExpense();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = transactions.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildColoredBox(
              color: Colors.red,
              title: 'Total Expenses',
              amount: totalExpenses,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${transactions[index]['category']} - \$${transactions[index]['amount'].toStringAsFixed(2)}'),
                    subtitle: Text(transactions[index]['date'].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildColoredBox({required Color color, required String title, required double amount}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

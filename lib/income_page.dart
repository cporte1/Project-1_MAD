import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  final Function(double) onUpdateIncomeTotal;

  IncomePage({required this.onUpdateIncomeTotal});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double incomeAmount = 0.0;
  final List<Map<String, dynamic>> transactions = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _addIncome() {
    if (incomeAmount > 0) {
      setState(() {
        transactions.add({
          'amount': incomeAmount,
          'date': DateTime.now(),
          'category': _categoryController.text,
        });
        widget.onUpdateIncomeTotal(transactions.fold<double>(
            0, (previousValue, transaction) => previousValue + transaction['amount']));
        _amountController.clear();
        _categoryController.clear();
      });
    }
  }

  void _showAddIncomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Income"),
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
                  incomeAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Add"),
              onPressed: () {
                _addIncome();
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
    double totalIncome = transactions.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Income'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildColoredBox(
              color: Colors.green,
              title: 'Total Income',
              amount: totalIncome,
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
        onPressed: _showAddIncomeDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
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

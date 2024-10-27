import 'package:flutter/material.dart';

class InvestmentPage extends StatefulWidget {
  final Function(double) onUpdateInvestmentsTotal;

  InvestmentPage({required this.onUpdateInvestmentsTotal});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  double investmentAmount = 0.0;
  final List<Map<String, dynamic>> investments = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _addInvestment() {
    if (investmentAmount > 0) {
      setState(() {
        investments.add({
          'amount': investmentAmount,
          'date': DateTime.now(),
          'name': _nameController.text,
        });
        widget.onUpdateInvestmentsTotal(investments.fold<double>(
            0, (previousValue, investment) => previousValue + investment['amount']));
        _amountController.clear();
        _nameController.clear();
      });
    }
  }

  void _showAddInvestmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Investment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Investment Name'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  investmentAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Add"),
              onPressed: () {
                _addInvestment();
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
    double totalInvestments = investments.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Investments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildColoredBox(
              color: Colors.purple,
              title: 'Total Investments',
              amount: totalInvestments,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: investments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${investments[index]['name']} - \$${investments[index]['amount'].toStringAsFixed(2)}'),
                    subtitle: Text(investments[index]['date'].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInvestmentDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
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

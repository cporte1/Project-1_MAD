import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InvestmentPage extends StatefulWidget {
  final Function(double) onUpdateInvestmentsTotal;

  InvestmentPage({required this.onUpdateInvestmentsTotal});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  double investmentAmount = 0.0;
  final List<Map<String, dynamic>> investments = [];
  final List<FlSpot> investmentHistory = [FlSpot(0, 0)]; // Initialize with a starting point
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  int investmentIndex = 1;

  void _addInvestment() {
    if (investmentAmount > 0) {
      setState(() {
        investments.add({
          'amount': investmentAmount,
          'date': DateTime.now(),
          'name': _nameController.text,
        });
        _updateTotalInvestments();
        _amountController.clear();
        _nameController.clear();
      });
    }
  }

  void _editInvestment(int index) {
    final investment = investments[index];
    _amountController.text = investment['amount'].toString();
    _nameController.text = investment['name'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Investment"),
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
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  investments[index] = {
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                    'date': investment['date'],
                    'name': _nameController.text,
                  };
                  _updateTotalInvestments();
                });
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

  void _showAddInvestmentDialog() {
    _amountController.clear();
    _nameController.clear();

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

  void _updateTotalInvestments() {
    double totalInvestments = investments.fold(0, (sum, item) => sum + item['amount']);
    widget.onUpdateInvestmentsTotal(totalInvestments);

    setState(() {
      // Safely update the investment history graph data
      investmentHistory.add(FlSpot(investmentIndex.toDouble(), totalInvestments));
      investmentIndex++;
    });
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
            SizedBox(height: 16),
            _buildInvestmentChart(),
            Expanded(
              child: ListView.builder(
                itemCount: investments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${investments[index]['name']} - \$${investments[index]['amount'].toStringAsFixed(2)}'),
                    subtitle: Text(investments[index]['date'].toString()),
                    onTap: () => _editInvestment(index),
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

  Widget _buildInvestmentChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hide grid lines for cleanliness
          borderData: FlBorderData(show: false), // Hide borders around the chart
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide left axis titles
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide bottom axis titles
          ),
          lineBarsData: [
            LineChartBarData(
              spots: investmentHistory,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: false), // Hide dots for a cleaner line
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NetSpendingPage extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double totalInvestments;

  NetSpendingPage({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalInvestments,
  });

  double get netWorth => totalIncome + totalInvestments - totalExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Net Spending'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Income Box
            _buildColoredBox(
              color: Colors.green,
              title: 'Total Income',
              amount: totalIncome,
            ),
            SizedBox(height: 16),
            // Total Expenses Box
            _buildColoredBox(
              color: Colors.red,
              title: 'Total Expenses',
              amount: totalExpenses,
            ),
            SizedBox(height: 16),
            // Net Worth Box
            _buildColoredBox(
              color: Colors.lightBlue, // Light blue for Net Worth
              title: 'Net Worth',
              amount: netWorth,
            ),
            SizedBox(height: 16),
            // Net Spending Box
            _buildColoredBox(
              color: Colors.orange,
              title: 'Net Spending',
              amount: totalIncome - totalExpenses,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColoredBox(
      {required Color color, required String title, required double amount}) {
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

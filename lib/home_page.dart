import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final double incomeTotal;
  final double expensesTotal;
  final double investmentsTotal;

  HomePage({
    required this.incomeTotal,
    required this.expensesTotal,
    required this.investmentsTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildColoredBox(
                    color: Colors.green,
                    title: 'Total Income',
                    amount: incomeTotal,
                  ),
                  SizedBox(height: 16),
                  _buildColoredBox(
                    color: Colors.red,
                    title: 'Total Expenses',
                    amount: expensesTotal,
                  ),
                  SizedBox(height: 16),
                  _buildColoredBox(
                    color: Colors.purple,
                    title: 'Total Investments',
                    amount: investmentsTotal,
                  ),
                  SizedBox(height: 16),
                  _buildColoredBox(
                    color: Colors.orange,
                    title: 'Net Spending',
                    amount: incomeTotal - expensesTotal,
                  ),
                ],
              ),
            ),
          ],
        ),
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
import 'package:flutter/material.dart';
import 'package:finance_management_app/home_page.dart';
import 'package:finance_management_app/income_page.dart';
import 'package:finance_management_app/expense_page.dart';
import 'package:finance_management_app/investment_page.dart';
import 'package:finance_management_app/net_spending_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String username = '';
  double incomeTotal = 0.0;
  double expensesTotal = 0.0;
  double investmentsTotal = 0.0;

  void _updateIncomeTotal(double newTotal) {
    setState(() {
      incomeTotal = newTotal;
    });
  }

  void _updateExpensesTotal(double newTotal) {
    setState(() {
      expensesTotal = newTotal;
    });
  }

  void _updateInvestmentsTotal(double newTotal) {
    setState(() {
      investmentsTotal = newTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: username.isEmpty
          ? NameEntryPage(
        onSubmit: (name) {
          setState(() {
            username = name;
          });
        },
      )
          : MainNavigation(
        username: username,
        incomeTotal: incomeTotal,
        expensesTotal: expensesTotal,
        investmentsTotal: investmentsTotal,
        onUpdateIncomeTotal: _updateIncomeTotal,
        onUpdateExpensesTotal: _updateExpensesTotal,
        onUpdateInvestmentsTotal: _updateInvestmentsTotal,
      ),
    );
  }
}

class NameEntryPage extends StatelessWidget {
  final Function(String) onSubmit;

  NameEntryPage({required this.onSubmit});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Name Here:",
                style: TextStyle(fontSize: 24),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20), // Spacing
              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text;
                  if (name.isNotEmpty) {
                    onSubmit(name);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final String username;
  final double incomeTotal;
  final double expensesTotal;
  final double investmentsTotal;
  final Function(double) onUpdateIncomeTotal;
  final Function(double) onUpdateExpensesTotal;
  final Function(double) onUpdateInvestmentsTotal;

  MainNavigation({
    required this.username,
    required this.incomeTotal,
    required this.expensesTotal,
    required this.investmentsTotal,
    required this.onUpdateIncomeTotal,
    required this.onUpdateExpensesTotal,
    required this.onUpdateInvestmentsTotal,
  });

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
        username: widget.username,
        incomeTotal: widget.incomeTotal,
        expensesTotal: widget.expensesTotal,
        investmentsTotal: widget.investmentsTotal,
      ),
      IncomePage(onUpdateIncomeTotal: widget.onUpdateIncomeTotal),
      ExpensePage(onUpdateExpensesTotal: widget.onUpdateExpensesTotal),
      InvestmentPage(onUpdateInvestmentsTotal: widget.onUpdateInvestmentsTotal),
      NetSpendingPage(totalIncome: widget.incomeTotal, totalExpenses: widget.expensesTotal, totalInvestments: widget.investmentsTotal)
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.yellow), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money, color: Colors.green), label: 'Income'),
          BottomNavigationBarItem(icon: Icon(Icons.money_off, color: Colors.red), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up, color: Colors.purple), label: 'Investments'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate, color: Colors.orange), label: 'Net Spending'),
        ],
      ),
    );
  }
}

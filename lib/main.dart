import 'package:finance_management_app/TransactionData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  void addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextField(
            controller: newExpenseNameController,
          ),
          TextField(
            controller: newExpenseAmountController,
          ),
        ],
        ),
        actions: [
          MaterialButton(onPressed: save, child: Text('Save'),),
          MaterialButton(onPressed: cancel, child: Text('Cancel'),),
        ],
    ),
    );
  }

void save() {
  Expense newExpense = Expense(
    name: newExpenseNameController.text,
    amount: newExpenseAmountController.text,
    dateTime: DateTime.now,
  );
  Provider.of<ExpenseData>(context, listen: false).addExpense(newExpense);
  Navigator.pop(context);
  newExpenseNameController.clear();
}

void cancel() {
  Navigator.pop(context);
  newExpenseAmountController.clear();
}
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey,
        floatingActionButton: FloatingActionButton(
          onPressed: addExpense,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getExpenseList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getExpenseList()[index].name),
            subtitle: Text(value.getExpenseList()[index].dateTime.toString()),
            trailing: Text('\$' + value.getExpenseList()[index].amount),
          ),
        ),
      ),
    );
  }
}

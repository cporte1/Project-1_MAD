enum TransactionType {income, expense}
enum itemCategory {grocery, clothing, gas, bills, payments, transfers}

class UserData {
  final String name;
  final String totalBalance;
  final String income;
  final String expense;
  final List<Transactions> transactions;

  const UserData({
    required this.name,
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.transactions
});
}

class Transaction {
  final itemCategory category;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final String amount;
  final String date;

  const Transaction(this.category, this.transactionType, this.itemCategoryName, this.amount, this.date, this.itemName);
}



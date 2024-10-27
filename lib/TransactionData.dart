import 'package:flutter/cupertino.dart';

class Expense {

}

class ExpenseData extends ChangeNotifier {
  List<Expense> ExpenseList = [];
  List<Expense> getExpenseList(){
    return ExpenseList;
  }

  void addExpense(Expense newExpense) {
    ExpenseList.add(newExpense);
  }

  void deleteExpense(Expense expense) {
    ExpenseList.remove(expense);
  }

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
        break;
      default: '';
    }
  }

  DateTime startOfWeekDay() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++){
      if (getDayName(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calculateDailyNetSpend() {
    Map<String, double> dailyNetSpend = {

    };
    for (var expense in ExpenseList) {
      String date = dateToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyNetSpend.containsKey(date)) {
        double currentAmount = dailyNetSpend[date]!;
        currentAmount += amount;
        dailyNetSpend[date] = currentAmount;
      } else {
        dailyNetSpend.addAll({date: amount});
      }
    }
    return dailyNetSpend;
  }



  String dateToString(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    if (day.length == 1){
      day = '0' + day;
    }
    String date = year + month + day;

    return date;
  }
}
import 'package:flutter/material.dart';
import 'package:noteapp/database/ExpenseDb.dart';
import 'package:noteapp/models/ExpenseModel.dart';

class ExpenseListProvider extends ChangeNotifier {
  List<ExpenseModel> _expenselist = [];
  bool isLoading = true;
  void updateExpense() async {
    isLoading = true;
    _expenselist = await ExpenseDbHelper.instance.getAllExpense();
    isLoading = false;

    notifyListeners();
  }

  List<ExpenseModel> getExpenseList(int userId) {
    return _expenselist.where((element) => element.userId == userId).toList();
  }
}

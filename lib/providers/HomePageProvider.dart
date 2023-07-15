import 'package:flutter/material.dart';
import 'package:noteapp/enum/Pages.dart';

class HomePageProvider extends ChangeNotifier {
  Pages curPage = Pages.Expense;
  void changePage(Pages newPage) {
    curPage = newPage;
    notifyListeners();
  }
}

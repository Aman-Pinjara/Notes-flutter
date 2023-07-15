// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ExpenseCategory {
  Food,
  Shopping,
  Travel,
  Entertainment,
  Others,
}

// function to get the string value of the enum
String getExpenseCategoryString(ExpenseCategory category) {
  switch (category) {
    case ExpenseCategory.Food:
      return 'Food';
    case ExpenseCategory.Shopping:
      return 'Shopping';
    case ExpenseCategory.Travel:
      return 'Travel';
    case ExpenseCategory.Entertainment:
      return 'Entertainment';
    case ExpenseCategory.Others:
      return 'Others';
  }
}

// function to get the enum value from the string value
ExpenseCategory getExpenseCategory(String category) {
  switch (category) {
    case 'Food':
      return ExpenseCategory.Food;
    case 'Shopping':
      return ExpenseCategory.Shopping;
    case 'Travel':
      return ExpenseCategory.Travel;
    case 'Entertainment':
      return ExpenseCategory.Entertainment;
    case 'Others':
      return ExpenseCategory.Others;
    default:
      return ExpenseCategory.Others;
  }
}

// function to get the icon of the enum value
IconData getExpenseCategoryIcon(ExpenseCategory category) {
  switch (category) {
    case ExpenseCategory.Food:
      return Icons.fastfood;
    case ExpenseCategory.Shopping:
      return Icons.shopping_cart;
    case ExpenseCategory.Travel:
      return Icons.directions_car;
    case ExpenseCategory.Entertainment:
      return Icons.movie;
    case ExpenseCategory.Others:
      return Icons.more_horiz;
  }
}


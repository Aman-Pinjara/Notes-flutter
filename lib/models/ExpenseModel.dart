import 'package:noteapp/enum/ExpenseCategory.dart';
import 'package:noteapp/database/ExpenseDb.dart';

class ExpenseModel {
  int? id;
  int userId;
  String name;
  double amount;
  bool isCredit;
  DateTime date;
  DateTime lastEdited;
  ExpenseCategory category;
  String description;

  ExpenseModel({
    this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.date,
    required this.lastEdited,
    this.isCredit = false,
    this.category = ExpenseCategory.Others,
    this.description = "",
  });

  static ExpenseModel fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[ExpenseTableName.id],
      userId: json[ExpenseTableName.userId],
      name: json[ExpenseTableName.name],
      amount: json[ExpenseTableName.amount].toDouble(),
      date: DateTime.parse(json[ExpenseTableName.date]),
      lastEdited: DateTime.parse(json[ExpenseTableName.lastEdited]),
      isCredit: json[ExpenseTableName.isCredit] == 1,
      category: getExpenseCategory(json[ExpenseTableName.category]),
      description: json[ExpenseTableName.description],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data[ExpenseTableName.id] = id;
    data[ExpenseTableName.userId] = userId;
    data[ExpenseTableName.name] = name;
    data[ExpenseTableName.amount] = amount;
    data[ExpenseTableName.date] = date.toIso8601String();
    data[ExpenseTableName.lastEdited] = lastEdited.toIso8601String();
    data[ExpenseTableName.isCredit] = isCredit ? 1 : 0;
    data[ExpenseTableName.category] = getExpenseCategoryString(category);
    data[ExpenseTableName.description] = description;

    return data;
  }

  ExpenseModel copy({
    int? id,
    int? userId,
    String? name,
    double? amount,
    bool? isCredit,
    DateTime? date,
    DateTime? lastEdited,
    ExpenseCategory? category,
    String? description,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isCredit: isCredit ?? this.isCredit,
      date: date ?? this.date,
      lastEdited: lastEdited ?? this.lastEdited,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:noteapp/database/UserDb.dart';
import 'package:noteapp/enum/ExpenseCategory.dart';
import 'package:noteapp/database/ExpenseDb.dart';
import 'package:noteapp/providers/ExpenseListProvider.dart';
import 'package:noteapp/models/ExpenseModel.dart';
import 'package:provider/provider.dart';

import '../../models/UserModel.dart';
import '../../providers/UserListProvider.dart';

class ExpenseAddPage extends StatefulWidget {
  const ExpenseAddPage({Key? key}) : super(key: key);

  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  ExpenseCategory selectedCategory = ExpenseCategory.Others;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isCredit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
          ),
          DropdownButton<ExpenseCategory>(
            value: selectedCategory,
            items: ExpenseCategory.values
                .map((e) => DropdownMenuItem<ExpenseCategory>(
                      child: Text(getExpenseCategoryString(e)),
                      value: e,
                    ))
                .toList(),
            onChanged: (newval) {
              setState(() {
                selectedCategory = newval!;
              });
            },
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          Switch(
            value: isCredit,
            onChanged: (value) {
              setState(() {
                isCredit = value;
              });
            },
          ),
          TextButton(
            onPressed: () async {
              int userid =
                  Provider.of<UserListProvider>(context, listen: false).curUser;
              ExpenseModel expense = ExpenseModel(
                name: nameController.value.text,
                userId: userid,
                amount: double.parse(amountController.value.text),
                date: DateTime.now(),
                lastEdited: DateTime.now(),
                isCredit: isCredit,
                category: selectedCategory,
                description: descriptionController.value.text,
              );
              double newTotal = Provider.of<UserListProvider>(context, listen: false)
                      .getUser(userid).totalBalance;
              if (isCredit) {
                newTotal += double.parse(amountController.value.text);
              } else {
                newTotal -= double.parse(amountController.value.text);
              }
              Navigator.pop(context);
              await ExpenseDbHelper.instance.insertDB(expense);
              await UserDbHelper.instance.updateTotal(
                userid, newTotal
              );
              Provider.of<UserListProvider>(context, listen: false)
                  .updateAmount(newTotal); 
              Provider.of<ExpenseListProvider>(context, listen: false)
                  .updateExpense();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

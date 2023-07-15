// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:noteapp/common/Colors.dart';
import 'package:noteapp/common/MyDrawer.dart';
import 'package:noteapp/enum/ExpenseCategory.dart';
import 'package:noteapp/pages/expense/ExpenseAddPage.dart';
import 'package:noteapp/pages/expense/UserAddPage.dart';
import 'package:noteapp/providers/ExpenseListProvider.dart';
import 'package:noteapp/models/ExpenseModel.dart';
import 'package:provider/provider.dart';

import '../../models/UserModel.dart';
import '../../providers/UserListProvider.dart';

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({Key? key}) : super(key: key);

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  List<UserModel> userList = [];
  late int curUser;
  List<ExpenseModel> expenseList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ExpenseListProvider>(context, listen: false).updateExpense();
      Provider.of<UserListProvider>(context, listen: false).updateUserList();
    });
    super.initState();
  }

  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    bool isUserLoading = Provider.of<UserListProvider>(context).isLoading;
    bool isExpenseLoading = Provider.of<UserListProvider>(context).isLoading;
    userList = Provider.of<UserListProvider>(context).userList;
    if (!isUserLoading) {
      curUser = Provider.of<UserListProvider>(context).curUser;
      expenseList =
          Provider.of<ExpenseListProvider>(context).getExpenseList(curUser);
    }
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserAddPage()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: MyColors.secondary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/abstract.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          isUserLoading || isExpenseLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  Provider.of<UserListProvider>(context,
                                          listen: false)
                                      .updateCurUser(index);
                                },
                                scrollPhysics: const BouncingScrollPhysics(),
                                enableInfiniteScroll: false,
                                initialPage: 0,
                                reverse: false,
                                autoPlay: false,
                                enlargeFactor: 0.3,
                                disableCenter: true,
                                // padEnds: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                              items: userList.map((e) {
                                return userTile(
                                  e,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: expenseListWidget(),
                    ),
                  ],
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseAddPage(),
            ),
          );
        },
        elevation: 1,
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }

  Padding userTile(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white.withOpacity(0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      color: MyColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Center(
                    child: Text(
                      "₹ ${user.totalBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 80.0),
                    child: Text(
                      user.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget expenseListWidget() {
    if (expenseList.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ExpenseTile(
            expense: expenseList[index],
          );
        },
        itemCount: expenseList.length,
      );
    } else {
      return Center(
        child: Text("No Expenses"),
      );
    }
  }
}

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  const ExpenseTile({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.light,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.dark.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      getExpenseCategoryIcon(expense.category),
                      color: MyColors.secondary,
                    ),
                  ),
                  SizedBox(width: 30),
                  Text(
                    expense.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${expense.isCredit ? '+' : '-'} ₹${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: expense.isCredit ? Colors.green : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    getDate(expense.date),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDate(DateTime date) {
    if (date.isToday()) {
      return "Today";
    } else if (date.isYesterday()) {
      return "Yesterday";
    } else {
      final difference = DateTime.now().difference(date);
      if (difference.inDays < 29) {
        return "${(difference.inDays ~/ 7)} weeks ago";
      } else if (difference.inDays < 365) {
        return "${difference.inDays ~/ 30} months ago";
      } else {
        return "${difference.inDays ~/ 365} years ago";
      }
    }
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:noteapp/HomePageProvider.dart';
import 'package:noteapp/enum/Pages.dart';
import 'package:noteapp/note/NoteHome.dart';
import 'package:provider/provider.dart';

import '../expense/ExpenseHome.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    Pages cur = Provider.of<HomePageProvider>(context).curPage;
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.amber,
            child: Icon(
              cur == Pages.Note ? Icons.note : Icons.attach_money_outlined,
              size: 50,
              color: Colors.white,
            ),
          ),
          DrawerHeader(
            margin: EdgeInsets.only(bottom: 0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Hello, \n',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Hope you have a good day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.amber.shade200,
                        )),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Note",
              style: TextStyle(
                fontSize: cur == Pages.Note ? 18 : 15,
                fontWeight:
                    cur == Pages.Note ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              switch (cur) {
                case Pages.Note:
                  Navigator.of(context).pop();
                  break;
                case Pages.Expense:
                 Provider.of<HomePageProvider>(context, listen: false)
                      .changePage(Pages.Note);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const NoteHome()),
                  );
                  break;
              }
            },
          ),
          ListTile(
            title: Text(
              "Expense",
              style: TextStyle(
                fontSize: cur == Pages.Expense ? 18 : 15,
                fontWeight:
                    cur == Pages.Expense ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              switch (cur) {
                case Pages.Note:
                  Provider.of<HomePageProvider>(context, listen: false)
                      .changePage(Pages.Expense);
                      Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ExpenseHome()),
                  );
                  break;
                case Pages.Expense:
                  Navigator.of(context).pop();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

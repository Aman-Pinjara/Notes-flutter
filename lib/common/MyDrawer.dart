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
          ListTile(
            title: const Text("Note"),
            onTap: () {
              switch (cur) {
                case Pages.Note:
                  Navigator.of(context).pop();
                  break;
                case Pages.Expense:
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const NoteHome()),
                  );
                  Provider.of<HomePageProvider>(context, listen: false)
                      .changePage(Pages.Note);
                  break;
              }
            },
          ),
          ListTile(
            title: const Text("Expense"),
            onTap: () {
              switch (cur) {
                case Pages.Note:
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ExpenseHome()),
                  );
                  Provider.of<HomePageProvider>(context, listen: false)
                      .changePage(Pages.Expense);
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

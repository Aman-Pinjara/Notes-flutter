import 'package:flutter/material.dart';
import 'package:noteapp/providers/HomePageProvider.dart';
import 'package:noteapp/pages/expense/ExpenseHome.dart';
import 'package:noteapp/providers/ExpenseListProvider.dart';
import 'package:noteapp/providers/NoteListProvider.dart';
import 'package:provider/provider.dart';

import 'pages/note/NoteHome.dart';
import 'providers/UserListProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteListProvider>(
          create: (_) => NoteListProvider(),
        ),
        ChangeNotifierProvider<HomePageProvider>(
          create: (_) => HomePageProvider(),
        ),
        ChangeNotifierProvider<ExpenseListProvider>(
          create: (_) => ExpenseListProvider(),
        ),
        ChangeNotifierProvider<UserListProvider>(
          create: (_) => UserListProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Provider.of<NoteListProvider>(context, listen: false).noteupdate();
    return const MaterialApp(
      title: 'Notes App',
      home: ExpenseHome(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:noteapp/HomePageProvider.dart';
import 'package:noteapp/note/NoteListProvider.dart';
import 'package:provider/provider.dart';

import 'note/NoteHome.dart';

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
      ],
      child: MyApp(),
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
      home: NoteHome(),
    );
  }
}

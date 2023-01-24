import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notesdb.dart';
import 'NoteListProvider.dart';
import 'NoteModel.dart';

class NoteAddPage extends StatefulWidget {
  const NoteAddPage({Key? key}) : super(key: key);

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  bool saved = false;
  String title = "";
  String des = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () async {
              String titleIn = title;
              // print(titleIn);
              if (title == "" && des != "") {
                titleIn = des.length > 20 ? des.substring(0, 20) : des;
              } else if (title == "" && des == "") {
                // print('NOt added inside');
                Navigator.of(context).pop();
                return;
              }
              await NoteDbHelper.instance
                  .insertDB(Note(title: titleIn, pinned: saved, des: des));
              Provider.of<NoteListProvider>(context, listen: false)
                  .noteupdate();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save_alt_sharp),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  saved = !saved;
                });
              },
              icon: saved
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              onChanged: (titleText) {
                title = titleText;
              },
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              maxLines: 1,
            ),
            Expanded(
              child: TextField(
                onChanged: (desText) {
                  des = desText;
                },
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
                expands: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
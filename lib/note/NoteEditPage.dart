import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notesdb.dart';
import 'NoteListProvider.dart';
import 'NoteModel.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;
  const NoteEditPage({required this.note, Key? key}) : super(key: key);

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  bool? saved;
  final titleController = TextEditingController();
  final desController = TextEditingController();
  String title = "";
  String des = "";
  @override
  void initState() {
    titleController.text = title = widget.note.title;
    desController.text = des = widget.note.des ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool cursaved = widget.note.pinned;
    return Scaffold(
      backgroundColor: widget.note.pinned ? Colors.amber[100] : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () async {
              bool? cancel = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm delete'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (cancel != null && cancel) {
                NoteDbHelper.instance.deleteNote(widget.note.id!);
                Provider.of<NoteListProvider>(context, listen: false)
                    .noteupdate();
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                saved ??= cursaved;
                saved = !saved!;
              });
            },
            icon: saved ?? cursaved
                ? const Icon(Icons.bookmark)
                : const Icon(Icons.bookmark_outline),
          ),
          IconButton(
              onPressed: () async {
                String titleIn = title;
                if (title == "" && des != "") {
                  titleIn = des.length > 20 ? des.substring(0, 20) : des;
                } else if (title == "" && des == "") {
                  Navigator.of(context).pop();
                  return;
                }
                await NoteDbHelper.instance.updateNote(Note(
                    title: titleIn,
                    pinned: saved ?? cursaved,
                    des: des,
                    id: widget.note.id!));
                Provider.of<NoteListProvider>(context, listen: false)
                    .noteupdate();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save_alt_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              onChanged: ((value) => title = value),
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              controller: titleController,
              maxLines: 1,
            ),
            Expanded(
              child: TextField(
                onChanged: ((value) => des = value),
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
                expands: true,
                controller: desController,
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

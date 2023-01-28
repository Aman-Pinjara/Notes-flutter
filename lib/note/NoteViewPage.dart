import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notesdb.dart';
import 'NoteListProvider.dart';
import 'NoteModel.dart';

class NoteViewPage extends StatefulWidget {
  final Note note;
  const NoteViewPage({required this.note, Key? key}) : super(key: key);

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  bool? saved;
  @override
  Widget build(BuildContext context) {
    final bool cursaved = widget.note.pinned;
    return WillPopScope(
      onWillPop: () async {
        if (saved != null) {
          if (cursaved != saved!) {
            NoteDbHelper.instance.updateNote(Note(
                pinned: saved!,
                title: widget.note.title,
                des: widget.note.des,
                id: widget.note.id));
            Provider.of<NoteListProvider>(context, listen: false).noteupdate();
          }
        }
        return true;
      },
      child: Hero(
        tag: widget.note.id!,
        child: Scaffold(
          backgroundColor:
              widget.note.pinned ? Colors.amber[100] : Colors.white,
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
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(widget.note.title,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.note.des ?? "",
                        style: const TextStyle(
                            fontSize: 15.0, overflow: TextOverflow.clip),
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

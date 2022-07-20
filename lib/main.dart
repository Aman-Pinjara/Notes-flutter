import 'dart:developer';

import 'package:flutter/material.dart';
import 'notesdb.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (_) => NoteListProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<NoteListProvider>(context,listen: false).noteupdate();
    return const MaterialApp(
      title: 'Notes App',
      home: NoteHome(),
    );
  }
}

class NoteHome extends StatefulWidget {
  const NoteHome({Key? key}) : super(key: key);
  @override
  State<NoteHome> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  @override
  void dispose() {
    NoteDbHelper.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Notes'),
      ),
      body: gridNote(),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const NoteAddPage();
          }));
        },
      ),
    );
  }

  Widget gridNote() {
    List<Note> loadedNotes = Provider.of<NoteListProvider>(context).notelist;
    if (loadedNotes.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 13,
          itemBuilder: (BuildContext context, int position) {
            return tile(loadedNotes[position]);
          },
          itemCount: loadedNotes.length,
        ),
      );
    } else {
      return const Center(child: Text('No Notes Yet.........'));
    }
  }

  Widget tile(Note note) {
    bool saved = note.pinned;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: InkWell(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteViewPage(note: note)))
        },
        onDoubleTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditPage(note: note)))
        },
        child: Hero(
          tag: note.id!,
          child: Card(
            elevation: 2,
            color: saved ? Colors.amber[100] : Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(note.title,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    note.des ?? "",
                    style: const TextStyle(
                        fontSize: 15.0, overflow: TextOverflow.ellipsis),
                    maxLines: 5,
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
    titleController.text =title= widget.note.title;
    desController.text=des = widget.note.des ?? "";
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
              onPressed: ()async{
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
                          Navigator.pop(context, true)
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                if(cancel!=null && cancel){
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
              onPressed: ()async{
                String titleIn = title;
                if (title == "" && des != "") {
                  titleIn = des.length > 20 ? des.substring(0, 20) : des;
                } else if (title == "" && des == "") {
                  Navigator.of(context).pop();
                  return;
                }
                await NoteDbHelper.instance
                    .updateNote(Note(title: titleIn, pinned: saved ?? cursaved, des: des, id: widget.note.id!));
                Provider.of<NoteListProvider>(context, listen: false)
                    .noteupdate();
                Navigator.of(context).pop();
              }, 
              icon: const Icon(Icons.save_alt_sharp)
            )
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              onChanged: ((value) => title=value),
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
                onChanged: ((value) => des=value),
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
            Provider.of<NoteListProvider>(context, listen: false)
                .noteupdate();
          }
        }
        return true;
      },
      child: Hero(
        tag: widget.note.id!,
        child: Scaffold(
          backgroundColor: widget.note.pinned ? Colors.amber[100] : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                onPressed: ()async{
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
                            Navigator.pop(context, true)
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                  if(cancel!=null && cancel){
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

class NoteListProvider extends ChangeNotifier {
  List<Note> notelist = [];
  void noteupdate() async {
    notelist = await NoteDbHelper.instance.getAllNote();
    notifyListeners();
  }
}

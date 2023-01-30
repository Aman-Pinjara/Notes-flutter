// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:noteapp/common/MyDrawer.dart';
import 'package:provider/provider.dart';

import 'NoteAddPage.dart';
import 'NoteEditPage.dart';
import 'NoteListProvider.dart';
import 'NoteModel.dart';
import 'NoteViewPage.dart';

class NoteHome extends StatefulWidget {
  const NoteHome({Key? key}) : super(key: key);
  @override
  State<NoteHome> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  @override
  void dispose() {
    // NoteDbHelper.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: RawScrollbar(
        thumbVisibility: true,
        thickness: 5,
        thumbColor: Colors.amber.shade200.withOpacity(0.7),
        interactive: false,
        child: Stack(
          children: [
            Positioned(
              top: 650,
              left: -150,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: -170,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 280,
              left: -40,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              // ignore: prefer_const_literals_to_create_immutables
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  leading: Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                  backgroundColor: Colors.white,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned(
                          top: -60,
                          right: -30,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 70,
                          top: 90,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.cyanAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                        // ClipRRect(
                        //   child: BackdropFilter(
                        //     filter: ImageFilter.blur(
                        //       sigmaX: 7,
                        //       sigmaY: 7,
                        //     ),
                        //     child: Container(),
                        //   ),
                        // )
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 20),
                    centerTitle: true,
                    title: Text(
                      "Note",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  expandedHeight: 220,
                  centerTitle: true,
                ),
                gridNote()
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber.shade500,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const NoteAddPage();
              },
            ),
          );
        },
      ),
    );
  }

  Widget gridNote() {
    List<Note> loadedNotes = Provider.of<NoteListProvider>(context).notelist;
    if (loadedNotes.isNotEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.all(18.0),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 13,
          itemBuilder: (BuildContext context, int position) {
            return NoteTile(note: loadedNotes[position]);
          },
          childCount: loadedNotes.length,
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Text(
                  'No Notes Yet.........',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    bool saved = note.pinned;
    return GestureDetector(
      onLongPress: () {
        // NoteViewPage(context, note);
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            pageBuilder: (BuildContext context, _, __) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Hero(
                  tag: '${note.id!}title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.all(20),
                children: [
                  Hero(
                    tag: '${note.id!}des',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        note.des ?? "",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            }));
      },
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NoteEditPage(note: note)))
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: saved
                    ? Colors.amber.shade200.withOpacity(0.5)
                    : Colors.grey.shade200.withOpacity(0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Hero(
                      tag: '${note.id!}title',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Hero(
                      tag: '${note.id!}des',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          note.des ?? "",
                          style: const TextStyle(
                              fontSize: 15.0, overflow: TextOverflow.ellipsis),
                          maxLines: 5,
                        ),
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
}

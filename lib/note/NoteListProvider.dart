import 'package:flutter/material.dart';

import '../notesdb.dart';
import 'NoteModel.dart';

class NoteListProvider extends ChangeNotifier {
  List<Note> notelist = [];
  void noteupdate() async {
    notelist = await NoteDbHelper.instance.getAllNote();
    notifyListeners();
  }
}
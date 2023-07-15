import 'package:flutter/material.dart';

import '../database/notesdb.dart';
import '../models/NoteModel.dart';

class NoteListProvider extends ChangeNotifier {
  List<Note> notelist = [];
  void noteupdate() async {
    notelist = await NoteDbHelper.instance.getAllNote();
    notifyListeners();
  }
}
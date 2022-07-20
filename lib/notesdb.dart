//---------NOTE --------------------------

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String _tablename = 'notes';

class Note {
  final int? id;
  final bool pinned;
  final String title;
  final String? des;

  Note({this.id, required this.pinned, required this.title, this.des});

  Map<String, Object?> toJson() => {
        NoteTableName.id: id,
        NoteTableName.pinned: pinned ? 1 : 0,
        NoteTableName.title: title,
        NoteTableName.des: des
      };

  static Note toNote(Map<String, Object?> map) => Note(
      id: map[NoteTableName.id] as int?,
      pinned: map[NoteTableName.pinned] == 1,
      title: map[NoteTableName.title] as String,
      des: map[NoteTableName.des] as String?);

  Note copy({int? id, bool? pinned, String? title, String? des}) => (Note(
      id: id ?? this.id,
      pinned: pinned ?? this.pinned,
      title: title ?? this.title,
      des: des ?? this.des));
}

class NoteTableName {
  static const String id = '_id';
  static const String pinned = 'pinned';
  static const String title = 'title';
  static const String des = 'des';

  static final List<String> values = [id, pinned, title, des];
}

//--------------------DATABASE---------------------
class NoteDbHelper {
  NoteDbHelper._privateConstructor();
  static final NoteDbHelper instance = NoteDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDb('flutterNote.db');
    return _database!;
  }

  Future createDb(String dbName) async {
    String directory = await getDatabasesPath();
    String dbPath = join(directory, dbName);

    return await openDatabase(dbPath, version: 1, onCreate: createTable);
  }

//-----------------------CREATE TABLE QUERY-------------------------
  Future createTable(Database db, int version) async {
    const String createQuery = '''
      CREATE TABLE $_tablename (
        ${NoteTableName.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NoteTableName.pinned} BOOLEAN NOT NULL,
        ${NoteTableName.title} TEXT NOT NULL,
        ${NoteTableName.des} TEXT
      );
    ''';

    db.execute(createQuery);
  }

//--------------------INSERT QUERY-----------------------------
  Future<Note> insertDB(Note note) async {
    Database db = await instance.database;
    final id = await db.insert(_tablename, note.toJson());
    return note.copy(id: id);
  }

//------------------------GETTING A SINGLE NOTE FROM A DB---------------------------
  Future<Note> getnote(int id) async {
    Database db = await instance.database;
    final map = await db.query(_tablename,
        columns: NoteTableName.values,
        where: '${NoteTableName.id}= ?',
        whereArgs: [id]);

    if (map.isNotEmpty) {
      return Note.toNote(map.first);
    } else {
      throw Exception('The column with $id was not found');
    }
  }

//-----------------GET ALL THE ROWS IN THE TABLE------------------
  Future<List<Note>> getAllNote() async {
    Database db = await instance.database;
    final result = await db.query(_tablename);
    return result.map((dbobject) => Note.toNote(dbobject)).toList();
  }

//------------------UPDATE METHOD----------------------------
  Future updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update(_tablename, note.toJson(),
        where: '${NoteTableName.id} = ?', whereArgs: [note.id]);
  }

//-------------------DELETE METHOD----------------
  Future deleteNote(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_tablename, where: '${NoteTableName.id} = ?', whereArgs: [id]);
  }

//------------------CLOSING THE DATABASE-----------------------
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

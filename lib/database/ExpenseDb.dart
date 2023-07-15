import 'package:noteapp/models/ExpenseModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String _tablename = 'expense';

class ExpenseTableName {
  static const String id = '_id';
  static const String userId = 'userid';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String isCredit = 'isCredit';
  static const String date = 'date';
  static const String lastEdited = 'lastedited';
  static const String category = 'category';
  static const String description = 'description';

  static final List<String> values = [
    id,
    userId,
    name,
    amount,
    isCredit,
    date,
    lastEdited,
    category,
    description,
  ];
}

//--------------------DATABASE---------------------
class ExpenseDbHelper {
  ExpenseDbHelper._privateConstructor();
  static final ExpenseDbHelper instance = ExpenseDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDb('flutterexpense.db');
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
        ${ExpenseTableName.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ExpenseTableName.userId} INTEGER NOT NULL,
        ${ExpenseTableName.name} TEXT NOT NULL,
        ${ExpenseTableName.amount} Integer NOT NULL,
        ${ExpenseTableName.category} TEXT NOT NULL,
        ${ExpenseTableName.date} TEXT NOT NULL,
        ${ExpenseTableName.lastEdited} TEXT NOT NULL,
        ${ExpenseTableName.isCredit} Boolean NOT NULL,
        ${ExpenseTableName.description} TEXT
      );
    ''';

    db.execute(createQuery);
  }

//--------------------INSERT QUERY-----------------------------
  Future<ExpenseModel> insertDB(ExpenseModel expense) async {
    Database db = await instance.database;
    final id = await db.insert(_tablename, expense.toJson());
    return expense.copy(id: id);
  }

//------------------------GETTING A SINGLE NOTE FROM A DB---------------------------
  Future<ExpenseModel> getExpense(int id) async {
    Database db = await instance.database;
    final map = await db.query(
      _tablename,
      columns: ExpenseTableName.values,
      where: '${ExpenseTableName.id} = ?',
      whereArgs: [id],
    );
    return ExpenseModel.fromJson(map.first);
  }

//-----------------GET ALL THE ROWS IN THE TABLE------------------
  Future<List<ExpenseModel>> getAllExpense() async {
    Database db = await instance.database;
    final result =
        await db.query(_tablename, orderBy: '${ExpenseTableName.id} DESC');
    return result.map((dbobject) => ExpenseModel.fromJson(dbobject)).toList();
  }


//-----------------GET ALL THE ROWS IN THE TABLE------------------
  Future<List<ExpenseModel>> getAllExpenseOfUser(int userId) async {
    Database db = await instance.database;
    final result =
        await db.query(_tablename,where: '${ExpenseTableName.userId} = ?', whereArgs: [userId], orderBy: '${ExpenseTableName.id} DESC');
    return result.map((dbobject) => ExpenseModel.fromJson(dbobject)).toList();
  }

//------------------UPDATE METHOD----------------------------
  Future updateExpense(ExpenseModel note) async {
    Database db = await instance.database;
    return await db.update(
      _tablename,
      note.toJson(),
      where: '${ExpenseTableName.id} = ?',
      whereArgs: [note.id],
    );
  }

//-------------------DELETE METHOD----------------
  Future deleteExpense(int id) async {
    Database db = await instance.database;
    return await db.delete(_tablename,
        where: '${ExpenseTableName.id} = ?', whereArgs: [id]);
  }

//------------------CLOSING THE DATABASE-----------------------
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

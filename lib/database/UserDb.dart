import 'package:noteapp/models/UserModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String _tablename = 'users';

class UserTableName {
  static const String id = '_id';
  static const String name = 'name';
  static const String totalBalance = 'balance';
  static const String description = 'description';

  static final List<String> values = [
    id,
    name,
    totalBalance,
    description,
  ];
}

//--------------------DATABASE---------------------
class UserDbHelper {
  UserDbHelper._privateConstructor();
  static final UserDbHelper instance = UserDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDb('flutteruser.db');
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
        ${UserTableName.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${UserTableName.name} TEXT NOT NULL,
        ${UserTableName.totalBalance} Integer NOT NULL,
        ${UserTableName.description} TEXT
      );
    ''';

    await db.execute(createQuery);
    await db.insert(
        _tablename,
        UserModel(
                name: "Default",
                totalBalance: 0,
                description: "This is default user")
            .toJson());
  }

//--------------------INSERT QUERY-----------------------------
  Future<UserModel> insertUser(UserModel user) async {
    Database db = await instance.database;
    final id = await db.insert(_tablename, user.toJson());
    return user.copy(id: id);
  }

//------------------------GETTING A SINGLE NOTE FROM A DB---------------------------
  Future<UserModel> getUser(int id) async {
    Database db = await instance.database;
    final map = await db.query(_tablename,
        columns: UserTableName.values,
        where: '${UserTableName.id}= ?',
        whereArgs: [id],
);
    return UserModel.fromJson(map.first);
  }

//-----------------GET ALL THE ROWS IN THE TABLE------------------
  Future<List<UserModel>> getAllUsers() async {
    Database db = await instance.database;
    final result =
        await db.query(_tablename, orderBy: '${UserTableName.id} ASC');
    return result.map((dbobject) => UserModel.fromJson(dbobject)).toList();
  }

//------------------UPDATE METHOD----------------------------
  Future updateUser(UserModel user) async {
    Database db = await instance.database;
    return await db.update(
      _tablename,
      user.toJson(),
      where: '${UserTableName.id} = ?',
      whereArgs: [user.id],
    );
  }

//------------------UPDATE METHOD----------------------------
  Future updateTotal(int userid, double newAmount) async {
    Database db = await instance.database;
    return await db.update(
        _tablename,
        {
          UserTableName.totalBalance: newAmount,
        },
        where: '${UserTableName.id} = ?',
        whereArgs: [userid]);
  }

//-------------------DELETE METHOD----------------
  Future deleteUser(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_tablename, where: '${UserTableName.id} = ?', whereArgs: [id]);
  }

//------------------CLOSING THE DATABASE-----------------------
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  //singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database;

  static final tableName = 'item';
  static final columnId = 'id';
  static final user = 'user';
  static final cnpj = 'cnpj';
  static final serialNumber = 'serialNumber';
  static final name = 'name';
  static final number = 'number';
  static final supplier = 'supplier';
  static final model = 'model';
  static final type = 'type';
  static final description = 'description';
  static final incidentState = 'incidentState';
  static final location = 'location';
  static final observation = 'observation';

  Future<Database> getDatabase() async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'item_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY,
            $user TEXT,
            $cnpj INTEGER,
            $serialNumber TEXT,
            $name TEXT,
            $number INTEGER,
            $supplier TEXT,
            $model TEXT,
            $type TEXT,
            $description TEXT,
            $incidentState TEXT,
            $location TEXT,
            $observation TEXT
          )
          ''');
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryRowsPaginated(
      int page, int pageSize) async {
    Database db = await instance.database;
    int offset = (page - 1) * pageSize;
    return await db.query(
      tableName,
      limit: pageSize,
      offset: offset,
      orderBy: columnId,
    );
  }
}

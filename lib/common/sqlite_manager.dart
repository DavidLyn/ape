import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 数据库管理器
///
class DbManager {

  static Database db;

  static initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ape.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        });
  }

}
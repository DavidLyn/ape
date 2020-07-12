import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 数据库管理器
/// 参考 : https://www.jianshu.com/p/6656d81333cf
class DbManager {
  static Database db;

  // 打开 数据库
  static initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ape.db');

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {
    }

    // 参考 https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
    db = await openDatabase(path, version: 1,
        onConfigure: (Database db) async {
          print('DB onConfigure is called!');
        },
        onCreate: (Database db, int version) async {
          print('DB onCreate version $version');

          await db.execute(
              'CREATE TABLE Test (xid INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');

          // 好友表
          // id - 自增序号,主键
          // uid - 当前 App 用户id
          // friendId - 好友用户id
          // nickname - 好友昵称
          // avatar - 好友头像
          // profile - 好友简介
          // state - 0:好友  9:拉黑  2:发出加友请求等待对方确认  3:收到的加友请求尚未处理  4:拒绝收到的加友请求
          // isvalid - 1:有效 0:删除
          // friendTime - 成为好友时间
          // deleteTime - 删除时间
          await db.execute(
              'CREATE TABLE Friends (id INTEGER PRIMARY KEY, uid INTEGER, friendId INTEGER, nickname TEXT, avatar TEXT, profile TEXT, state INTEGER, isValid INTEGER, friendTime INTEGER, deleteTime INTEGER)');
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print('DB onUpgrade oldVersion:$oldVersion, newVersion=$newVersion');
        },
        onOpen: (Database db) async {
          print('DB onOpen version ${await db.getVersion()}');
        },
    );
  }

  // 删除 数据库    参考 https://pub.dev/packages/sqflite#-readme-tab-
  // CREATE TABLE Test (xid INTEGER PRIMARY KEY 中的 xid 竟然是自增的
  static deleteDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ape.db');

    await deleteDatabase(path);

    print('DB is deleted!');
  }

  // 测试
  static testDB() async {
    int id1 = await db.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
    print('DB inserted1: $id1');

    List<Map> list = await db.rawQuery('SELECT * FROM Test');
    print('DB list: $list');

  }

}
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

          // 好友申请表 - FriendAskfor
          // id - 自增序号,主键
          // msgId - 消息ID,用于关联 请求 和 响应
          // uid - 当前 App 用户id
          // friendId - 好友用户id
          // nickname - 好友昵称
          // avatar - 好友头像
          // profile - 好友简介
          // gender - 性别 1-男 2-女 0-保密
          // leavingWords - 留言
          // askforTime - 请求时间
          // state - 当前状态  0 - 发出请求尚未收到响应  1 - 对方已响应且已接受成为好友 2 - 对方已响应且已拒绝成为好友
          // responseTime - 收到响应时间
          // isValid - 1:有效 0:删除
          // deleteTime - 删除时间
          await db.execute(
              'CREATE TABLE FriendAskfor (id INTEGER PRIMARY KEY, msgId TEXT, uid INTEGER, friendId INTEGER, nickname TEXT, avatar TEXT, profile TEXT, gender INTEGER, leavingWords TEXT, askforTime INTEGER, state INTEGER, responseTime INTEGER, isValid INTEGER, deleteTime INTEGER)');

          // 好友邀约表 - FriendInviting
          // id - 自增序号,主键
          // msgId - 消息ID,用于关联 请求 和 响应
          // uid - 当前 App 用户id
          // friendId - 好友用户id
          // nickname - 好友昵称
          // avatar - 好友头像
          // profile - 好友简介
          // gender - 性别 1-男 2-女 0-保密
          // leavingWords - 留言
          // recieveTime - 收到时间
          // state - 状态 0 - 收到未处理 1 - 接受成为好友 2 - 拒绝成为好友
          // dealTime - 处理时间
          // isValid - 1:有效 0:删除
          // deleteTime - 删除时间
          await db.execute(
              'CREATE TABLE FriendInviting (id INTEGER PRIMARY KEY, msgId TEXT, uid INTEGER, friendId INTEGER, nickname TEXT, avatar TEXT, profile TEXT, gender INTEGER, leavingWords TEXT, recieveTime INTEGER, state INTEGER, dealTime INTEGER, isValid INTEGER, deleteTime INTEGER)');

          // 好友表 - Friend
          // id - 自增序号,主键
          // uid - 当前 App 用户id
          // friendId - 好友用户id
          // nickname - 好友昵称
          // avatar - 好友头像
          // profile - 好友简介
          // gender - 性别 1-男 2-女 0-保密
          // state - 1:好友  0:拉黑
          // isValid - 1:有效 0:删除
          // friendTime - 成为好友时间
          // rejectTime - 拉黑时间
          // deleteTime - 删除时间
          //
          // relation - 关系
          // updateTime - 修改时间

          await db.execute(
              'CREATE TABLE Friend (id INTEGER PRIMARY KEY, uid INTEGER, friendId INTEGER, nickname TEXT, avatar TEXT, profile TEXT, gender INTEGER, state INTEGER, isValid INTEGER, friendTime INTEGER, rejectTime INTEGER, deleteTime INTEGER, relation TEXT, updateTime INTEGER)');

          // 徽章表 - Badge
          // id - 自增序号,主键
          // keyName - 键
          // value - 值
          await db.execute(
              'CREATE TABLE Badge (id INTEGER PRIMARY KEY, keyName TEXT, value INTEGER)');

        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print('DB onUpgrade oldVersion:$oldVersion, newVersion=$newVersion');

//          if (oldVersion == 1 && newVersion == 2) {
//            // 增加 relation 字段
//            await db.execute("ALTER TABLE Friend ADD relation TEXT");
//          }

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
        'INSERT INTO Test(xid, name, value, num) VALUES(null, "some name", 1234, 456.789)');
    print('Table test inserted: $id1');

    List<Map> list = await db.rawQuery('SELECT * FROM Test');
    print('Table test list: $list');

  }

}
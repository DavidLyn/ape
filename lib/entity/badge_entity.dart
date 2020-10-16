import 'dart:async';
import 'package:ape/common/sqlite_manager.dart';

/// 徽章类
class BadgeEntity {

  static String tableName = 'Badge';

  int id;                  // 主键
  String keyName;          // 键名
  int value;               // 值

  BadgeEntity({
    this.id,
    this.keyName,
    this.value,
  });

  static BadgeEntity fromMap(Map<String, dynamic> map) {
    var badge = BadgeEntity();

    badge.id = map['id'];
    badge.keyName = map['keyName'];
    badge.value = map['value'];

    return badge;
  }

  static List<BadgeEntity> fromMapList(dynamic mapList) {
    List<BadgeEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  // 取得 Badge List
  static Future<List> getBadgeList() async {
    var result = await DbManager.db.rawQuery('select * from $tableName');
    return fromMapList(result.toList());
  }

  // 修改键值为指定值
  static Future<void> update(String keyName,int value) async {

    var count = await DbManager.db.rawUpdate('update $tableName set value = ? where keyName = ?',[value, keyName]);

    if (count == 0) {
      await DbManager.db.insert("$tableName", {'keyName':keyName,'value':value,});
    }
  }

  // set 键值为 1
  static void set(String keyName) {
    update(keyName,1);
  }

  // reset 键值为 0
  static void reset(String keyName) {
    update(keyName,0);
  }


  // 键值递增
  static Future<void> increment(String keyName,{int step : 1}) async {

    var count = await DbManager.db.rawUpdate('update $tableName set value = value + ? where keyName = ?',[step, keyName]);

    if (count == 0) {
      await DbManager.db.insert("$tableName", {'keyName':keyName,'value':step,});
    }
  }

}
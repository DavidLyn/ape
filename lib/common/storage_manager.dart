import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  /// app全局配置 eg:theme
  static SharedPreferences sharedPreferences;

  /// 临时目录 eg: cookie
  static Directory temporaryDirectory;


  /// 初始化必备操作 eg:user数据
  static LocalStorage localStorage;

  // 是否已经登录
  static bool _isLogined;

  bool get isLogined => _isLogined;

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('LocalStorage');   // Lvvv : 在文件系统的默认目录下中创建名称为 LocalStorage.json 的文件
    await localStorage.ready;

    _isLogined = sharedPreferences.getBool("kIsLogined") ?? false;
  }

  /// 设置已登录标志
  static setLogined() {
    sharedPreferences.setBool("kIsLogined", true);
  }
}

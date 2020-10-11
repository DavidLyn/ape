import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 应用文档管理器
class ApplicationDocumentManager {
  static Directory documentsDir;
  static String documentsPath;

  static init() async {
    documentsDir = await getApplicationDocumentsDirectory();
    documentsPath = documentsDir.path;
  }

  // 写文件
  static writeFile(String fileName, File file) async {
    File newFile = File(fileName);

    if(!newFile.existsSync()) {
      newFile.createSync();
    }

    newFile.writeAsBytesSync(file.readAsBytesSync());
  }

  // 删除文件
  static deleteFile(String fileName) async {
    File file = File(fileName);
    if(!file.existsSync()) {
      file.deleteSync();
    }
  }

}
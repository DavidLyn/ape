import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flustars/flustars.dart' as FlutterStars;

import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_selection_item.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/util/file_utils.dart';
import 'package:ape/common/widget/my_avatar.dart';

/// 个人信息 页面
///
class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var item = MySelectionItem(
      icon: Icon(Icons.access_time,color: Colors.green,),
      title: 'test',
      content: 'hello world',
    );

    item.onTap = () {
      item.setContent('切换成功!');
    };

    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '个人信息',
      ),
      body: Column(
        children: <Widget>[
          MySelectionItem(
            icon: Icon(Icons.title, color: Colors.green,),
            title: '头像',
            onTap: (){
              _selectAvatar(context);
            },
            image: MyAvatar(width: 28.0,height: 28.0,),
          ),
          item,
        ],
      ),
    );
  }

  _selectAvatar(BuildContext context) {
    showModalBottomSheet(
      context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('相机'),
                onTap: () async {
                  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  _saveImage(imageFile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('相册'),
                onTap: () async {
                  var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  _saveImage(imageFile);
                },
              ),
            ],
          );
        }
    );
  }

  Future _saveImage(File imageFile) async {

    if (imageFile == null) {
      Log.e('无效的图像文件');
      return;
    }

    // 根据 phone number 读取 uid
    var mobile = FlutterStars.SpUtil.getString(SpConstants.phoneNumber);
    var uid = FlutterStars.SpUtil.getInt(SpConstants.getMobileSpKey(mobile));

    if (uid == null || uid == 0) {
      Log.e('无效的 userID');
    }

    // 上传文件
    DioManager().uploadAvatar(
      NWApi.uploadAvatar,
      uid,
      imageFile,
      success : (data,message) {
        Log.d('avatar upload success');
      },
      error : (error) {
        Log.e("error code = ${error.code}, message = ${error.message}");
      }
    );

    // 删除原有头像文件
    var oldFile = FlutterStars.SpUtil.getString(SpConstants.userAvatar);

    if (oldFile.isNotEmpty) {
      ApplicationDocumentManager.deleteFile(oldFile);
    }

    // 保存当前头像文件
    String path = imageFile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    var newFile = '${ApplicationDocumentManager.documentsPath}/avatar.$suffix';

    ApplicationDocumentManager.writeFile(newFile, imageFile);

    // 记录新头像文件名
    FlutterStars.SpUtil.putString(SpConstants.userAvatar, newFile);

    // 刷新界面
    setState(() {

    });
  }
}

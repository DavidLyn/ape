import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:intl/intl.dart';

import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_selection_item.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/util/log_utils.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/util/file_utils.dart';
import 'package:ape/common/widget/my_avatar.dart';
import 'package:ape/global/global_router.dart';

/// 个人信息 页面
///
class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  var nickname = '武哇哇';
  var gender = '男';

  // 创建 GlobalKey 实现对内部 state 的访问
  GlobalKey<MySelectionItemState> _itemAvatarKey =
      GlobalKey<MySelectionItemState>();
  GlobalKey<MySelectionItemState> _itemNicknameKey =
      GlobalKey<MySelectionItemState>();
  GlobalKey<MySelectionItemState> _itemBirthdayKey =
      GlobalKey<MySelectionItemState>();
  GlobalKey<MySelectionItemState> _itemGenderKey =
      GlobalKey<MySelectionItemState>();

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
    print('PersonalInformationPage is rebuild');

    var itemAvatar = MySelectionItem(
      key: _itemAvatarKey,
      icon: Icon(
        Icons.title,
        color: Colors.green,
      ),
      title: '头像',
      image: MyAvatar(
        width: 28.0,
        height: 28.0,
      ),
    );

    itemAvatar.onTap = () {
      _selectAvatar(context);
    };

    var itemNickname = MySelectionItem(
      key: _itemNicknameKey,
      icon: Icon(
        Icons.add_to_photos,
        color: Colors.green,
      ),
      title: '昵称',
      content: nickname,
      onTap: () {
        Map<String, String> params = {
          'title': '修改昵称',
          'content': nickname,
          'hintText': '昵称',
          'maxLines': '1',
          'maxLength': '50',
          'keyboardType': 'text',
        };

        NavigatorUtils.pushWaitingResult(context, GlobalRouter.textEdit,
            (result) {
          nickname = result;

          _itemNicknameKey.currentState.setContent(nickname);
        }, params: params);
      },
    );

    var itemBirthday = MySelectionItem(
      key: _itemBirthdayKey,
      icon: Icon(
        Icons.access_time,
        color: Colors.green,
      ),
      title: '生日',
      content: '2001-01-05',
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2050),
          locale: Locale('zh'),
        );

        if (date != null) {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");

          _itemBirthdayKey.currentState.setContent(dateFormat.format(date));
        }
      },
    );

    var _itemGender = MySelectionItem(
      key: _itemGenderKey,
      icon: Icon(
        Icons.airline_seat_individual_suite,
        color: Colors.green,
      ),
      title: '性别',
      content: gender,
      onTap: () async {
        var result = await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              //title: Text('提示'),
              //message: Text('选择性别'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text('保密'),
                  onPressed: () {
                    Navigator.of(context).pop('0');
                  },
                  isDefaultAction: gender == '保密',
                ),
                CupertinoActionSheetAction(
                  child: Text('男'),
                  onPressed: () {
                    Navigator.of(context).pop('1');
                  },
                  isDefaultAction: gender == '男',
                  //isDestructiveAction: true,
                ),
                CupertinoActionSheetAction(
                  child: Text('女'),
                  onPressed: () {
                    Navigator.of(context).pop('2');
                  },
                  isDefaultAction: gender == '女',
                  //isDestructiveAction: true,
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('9');
                },
              ),
            );
          },
        );

        var gs;
        if (result != '9') {
          switch (result) {
            case '0': {
              gs = '保密';
            }
            break;
            case '1': {
              gs = '男';
            }
            break;
            case '2': {
              gs = '女';
            }
          }
        }

        if (gs != null) {
          _itemGenderKey.currentState.setContent(gs);
          gender = gs;
        }
      },
    );

    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '个人信息',
      ),
      body: Column(
        children: <Widget>[
          itemAvatar,
          itemNickname,
          itemBirthday,
          _itemGender,
        ],
      ),
    );
  }

  //_selectAvatar(BuildContext context,MySelectionItem item) {
  _selectAvatar(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('相机'),
                onTap: () async {
                  var imageFile =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  _saveImage(imageFile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('相册'),
                onTap: () async {
                  var imageFile =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  _saveImage(imageFile);
                },
              ),
            ],
          );
        });
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
    DioManager().uploadAvatar(NWApi.uploadAvatar, uid, imageFile,
        success: (data, message) {
      Log.d('avatar upload success');
    }, error: (error) {
      Log.e("error code = ${error.code}, message = ${error.message}");
    });

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
    _itemAvatarKey.currentState.setImage(MyAvatar(
      width: 28.0,
      height: 28.0,
    ));
  }
}

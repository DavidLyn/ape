import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/my_text_field.dart';
import 'package:ape/util/other_utils.dart';
import 'package:ape/network/dio_manager.dart';
import 'package:ape/network/nw_api.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/util/log_utils.dart';

/// 创建新群组
class GroupCreating extends StatefulWidget {
  @override
  _GroupCreatingState createState() => _GroupCreatingState();
}

class _GroupCreatingState extends State<GroupCreating> {

  File avatar;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _profileController = TextEditingController();
//  final FocusNode _nodeName = FocusNode();
//  final FocusNode _nodeProfile = FocusNode();

  @override
  void initState() {
    super.initState();

    avatar = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '创建新群',
        actionIcon: Icon(Icons.save),
        actionName: '保存',
        onPressed: () async {
          if (avatar == null) {
            OtherUtils.showToastMessage('请设置照片');
            return;
          }

          if (_nameController.text.isEmpty) {
            OtherUtils.showToastMessage('请设置名称');
            return;
          }

          await DioManager().createGroup( NWApi.createGroup, UserInfo.user.uid, _nameController.text, _profileController.text,
            avatar,
            success: (String data, String msg) {
              print('data = $data');
              print('message = $msg');
            },
            error: (error) {
              Log.e("Create group error! code = ${error.code}, message = ${error.message}");
              OtherUtils.showToastMessage(error.message ?? 'create group failed');
            },
          );

          NavigatorUtils.goBack(context);
        },
      ),
      body: Column(
        children: <Widget>[
          _itemPhoto(),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 16,right: 16,),
            child: MyTextField(
              key: const Key('name'),
              //focusNode: _nodeName,
              controller: _nameController,
              maxLength: 30,
              keyboardType: TextInputType.text,
              hintText: '请输入群名称(不超过30个字符)',
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 16,right: 16,),
            child: MyTextField(
              key: const Key('profile'),
              //focusNode: _nodeProfile,
              controller: _profileController,
              maxLength: 60,
              keyboardType: TextInputType.text,
              hintText: '请输入群简介(不超过60个字符)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPhoto() {
    return GestureDetector(
      onTap: () {
        _selectPhoto(context);
      },
      child: Center(
        child: avatar == null ? Container(
          margin: EdgeInsets.only(
            top: 8,
          ),
          alignment: Alignment.center,
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: Text('选择照片'),
        ) : Container(
          margin: EdgeInsets.only(
            top: 8,
          ),
          alignment: Alignment.center,
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
            image: DecorationImage(image: FileImage(avatar),fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  _selectPhoto(BuildContext context) {
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
                  var avatarNew =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (avatarNew != null) {
                    setState(() {
                      avatar = avatarNew;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('相册'),
                onTap: () async {
                  var avatarNew =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (avatarNew != null) {
                    setState(() {
                      avatar = avatarNew;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

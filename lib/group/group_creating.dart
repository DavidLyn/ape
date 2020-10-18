import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/global/global_router.dart';

/// 创建新群组
class GroupCreating extends StatefulWidget {
  @override
  _GroupCreatingState createState() => _GroupCreatingState();
}

class _GroupCreatingState extends State<GroupCreating> {
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
    return Scaffold(
      appBar: AppBarWithOneIcon(
        backgroundColor: Colors.green,
        centerTitle: '创建新群',
        actionIcon: Icon(Icons.save),
        actionName: '保存',
        onPressed: () {
//          NavigatorUtils.push(context, GlobalRouter.groupCreating);
        },
      ),
      body: Column(
        children: <Widget>[
          _itemPhoto(),
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
        child: Container(
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
          child: Container(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('选择照片'),
                ),
              ],
            ),
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
                  var imageFile =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  //_saveImage(imageFile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('相册'),
                onTap: () async {
                  var imageFile =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  //_saveImage(imageFile);
                },
              ),
            ],
          );
        });
  }
}

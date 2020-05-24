import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/common/widget/my_selection_item.dart';
import 'package:ape/util/other_utils.dart';

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

    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '个人信息',
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 5),
          MySelectionItem(
              title: '头像',
              onTap: (){
                _selectAvatar(context);
              }
          ),
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
                  if (imageFile == null) {
                    OtherUtils.showToastMessage('camera cancel!');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('相册'),
                onTap: () async {
                  var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
}

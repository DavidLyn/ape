import 'package:flutter/material.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/global/global_router.dart';

/// 群组管理
class GroupManagement extends StatefulWidget {
  @override
  _GroupManagementState createState() => _GroupManagementState();
}


class _GroupManagementState extends State<GroupManagement> {

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
        centerTitle: '吾群',
        actionIcon: Icon(Icons.add),
        actionName: '添加',
        onPressed: (){
          NavigatorUtils.push(context, GlobalRouter.groupCreating);
        },
      ),
      body:Container(
        child: Text('Hello my group!'),
      ),
    );
  }

}

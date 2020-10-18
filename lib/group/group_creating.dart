import 'package:flutter/material.dart';
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
        onPressed: (){
//          NavigatorUtils.push(context, GlobalRouter.groupCreating);
        },
      ),
      body:Container(
        child: Text('Hello create group!'),
      ),
    );
  }

}

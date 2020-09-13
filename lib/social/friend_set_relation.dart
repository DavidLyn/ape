import 'package:flutter/material.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';

/// 设置 朋友 关系
class FriendSetRelation extends StatefulWidget {
  @override
  _FriendSetRelationState createState() => _FriendSetRelationState();
}

class _FriendSetRelationState extends State<FriendSetRelation> {

  List<String> _selectedRelation = ['老师','师傅','徒弟','丈夫','基友','球友','老公','儿媳','女儿','上司'];

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
        centerTitle: '关系',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 已选 关系 标题
          _selectedTitle(),

          // 已选 关系 列表
          _selectedList(),

        ],
      ),
    );
  }

  Widget _selectedTitle() {
    return Container(
      margin: EdgeInsets.only(left: 10,top: 5,),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 5,)),
      ),
      child: Text(
        '已选关系',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _selectedList() {
    return Container(
      child: Wrap(
        children: List.generate(_selectedRelation.length, (i){
          return GestureDetector(
            onTap: (){

            },
            child: Container(
              child: Text(_selectedRelation[i]),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

}

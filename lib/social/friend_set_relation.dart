import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/widget/app_bar_with_one_icon.dart';
import 'package:ape/provider/friend_provider.dart';

/// 设置 朋友 关系
class FriendSetRelation extends StatefulWidget {

  // 已设置的关系
  final String relation;

  FriendSetRelation({this.relation});

  @override
  _FriendSetRelationState createState() => _FriendSetRelationState();
}

class _FriendSetRelationState extends State<FriendSetRelation> {

  List<String> _forSelectRelation = ['父亲','母亲','儿子','女儿','爷爷','奶奶','姥姥','姥爷','叔叔','婶婶','亲戚','老师','学生','导师','师兄','师弟','师姐','师妹'];
//  List<String> _forSelectRelation = List<String>();

//  List<String> _selectedRelation = ['老师','师傅','徒弟','丈夫','基友','球友','老公','儿媳','女儿','上司'];
  List<String> _selectedRelation = List<String>();

  @override
  void initState() {
    super.initState();

    if (widget.relation.isNotEmpty) {
      _selectedRelation.addAll(jsonDecode(widget.relation));
    }

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
        actionIcon: Icon(Icons.save),
        actionName: '保存',
        onPressed: (){
          NavigatorUtils.goBackWithParams(context, _selectedRelation);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 已选 关系 标题
          _selectedTitle(),

          // 已选 关系 列表
          _selectedList(),

          // 分隔线
          Container(
            margin: EdgeInsets.only(top:  10,left: 5,right: 5,),
            height: 2,
            color: Color(0xffEFEFEF),
          ),

          // 可选 关系 标题
          _forSelectTitle(),

          // 可选 关系 列表
          _forSelectList(),

        ],
      ),
    );
  }

  Widget _selectedTitle() {
    return Container(
      margin: EdgeInsets.only(left: 10,top: 15,),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2,color: Colors.orange,)),
      ),
      child: Text(
        '已选关系',
        style: TextStyle(
          fontSize: 20,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _selectedList() {
    return Container(
      margin: EdgeInsets.only(top: 10,left: 10,right: 10,),
      child: Wrap(
        children: List.generate(_selectedRelation.length, (i){
          return GestureDetector(
            onLongPress: () {
              showCupertinoDialog(
                context: context,
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('提示'),
                    content: Text('确认删除关系<${_selectedRelation[i]}>吗?'),
                    actions: <Widget>[
                      CupertinoDialogAction(child: Text('取消'),onPressed: (){
                        Navigator.pop(context);
                      },),
                      CupertinoDialogAction(child: Text('确认'),onPressed: () async {
                        setState(() {
                          _selectedRelation.removeAt(i);
                        });

                        Navigator.pop(context);
                      },),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5,),
              child: Container(
                padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1,),
                child: Text(_selectedRelation[i]),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _forSelectTitle() {
    return Container(
      margin: EdgeInsets.only(left: 10,top: 5,),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2,color: Colors.blue,)),
      ),
      child: Text(
        '可选关系',
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _forSelectList() {
    return Container(
      margin: EdgeInsets.only(top: 10,left: 10,right: 10,),
      child: Wrap(
        children: List.generate(_forSelectRelation.length, (i){
          return GestureDetector(
            onTap: () {
              if (_selectedRelation.indexOf(_forSelectRelation[i]) == -1) {
                setState(() {
                  _selectedRelation.add(_forSelectRelation[i]);
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5,),
              child: Container(
                padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1,),
                child: Text(_forSelectRelation[i]),
              ),
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

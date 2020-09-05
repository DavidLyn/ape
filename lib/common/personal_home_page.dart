import 'package:flutter/material.dart';

/// 个人主页
class PersonalHomePage extends StatefulWidget {
  @override
  _PersonalHomePageState createState() => _PersonalHomePageState();

  int uid;

  PersonalHomePage({this.uid});
}

class _PersonalHomePageState extends State<PersonalHomePage> {

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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              expandedHeight: 230.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('复仇者联盟'),
                background: Image.network(
                  'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemBuilder: (BuildContext context,int index){
            return Container(
              height: 80,
              color: Colors.primaries[index % Colors.primaries.length],
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }

}

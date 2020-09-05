import 'package:flutter/material.dart';

/// 个人主页
class PersonalHomePage extends StatefulWidget {
  @override
  _PersonalHomePageState createState() => _PersonalHomePageState();

  int uid;

  PersonalHomePage({this.uid});
}

class _PersonalHomePageState extends State<PersonalHomePage> {

  ScrollController _scrollController;
  bool _showTopBtn = false;
  double _height = 200.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > _height && !_showTopBtn) {
        _showTopBtn = true;
        setState(() {});
      } else if (_scrollController.offset < _height && _showTopBtn) {
        _showTopBtn = false;
        setState(() {});
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(),
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.green,
            actions: <Widget>[
              EmptyAnimatedSwitcher(
                display: _showTopBtn,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print('aaaaaaaaaa');
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                height: 200,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text('hello world',style: TextStyle(color: Colors.black,fontSize: 20,),),
              ),
              title: EmptyAnimatedSwitcher(
                display: _showTopBtn,
                child: Text('app title'),
              ),
            ),
            expandedHeight: 200,
            pinned: true,
          ),

          SliverGrid.count(crossAxisCount: 4,children: List.generate(8, (index){ return Container(
            color: Colors.primaries[index%Colors.primaries.length],
            alignment: Alignment.center,
            child: Text('$index',style: TextStyle(color: Colors.white,fontSize: 20),),
          ); }).toList(),),

          SliverList(
            delegate: SliverChildBuilderDelegate((content, index) { return Container(
              height: 85,
              alignment: Alignment.center,
              color: Colors.primaries[index % Colors.primaries.length],
              child: Text('$index',style: TextStyle(color: Colors.white,fontSize: 20),),
            );
            }, childCount: 25),
          ),
        ],
      ),
    );

//    return Scaffold(
//      body: NestedScrollView(
//        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
//          return <Widget>[
//            SliverAppBar(
//              expandedHeight: 200.0,
//              pinned: true,
//              title: Text('Hello World',style: TextStyle(color: Colors.black,),),
//              actions: <Widget>[
//                IconButton(icon: Icon(Icons.add), onPressed: (){
//
//                },)
//              ],
//              flexibleSpace: FlexibleSpaceBar(
//                title: Text('复仇者联盟'),
//                background: Image.network(
//                  'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
//                  fit: BoxFit.fitHeight,
//                ),
//              ),
//            ),
//          ];
//        },
//        body: ListView.builder(
//          itemBuilder: (BuildContext context,int index){
//            return Container(
//              height: 80,
//              color: Colors.primaries[index % Colors.primaries.length],
//              alignment: Alignment.center,
//              child: Text(
//                '$index',
//                style: TextStyle(color: Colors.white, fontSize: 20),
//              ),
//            );
//          },
//          itemCount: 20,
//        ),
//      ),
//    );
  }

}

/// 在 child 改变时执行缩放动画
class ScaleAnimatedSwitcher extends StatelessWidget {
  final Widget child;

  ScaleAnimatedSwitcher({this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: child,
    );
  }
}

class EmptyAnimatedSwitcher extends StatelessWidget {
  final bool display;
  final Widget child;

  EmptyAnimatedSwitcher({this.display: true, this.child});

  @override
  Widget build(BuildContext context) {
    return ScaleAnimatedSwitcher(child: display ? child : SizedBox.shrink());
  }
}


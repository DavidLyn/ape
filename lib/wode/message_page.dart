import 'package:flutter/material.dart';
import 'package:ape/util/other_utils.dart';

/// 消息 页面
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Message Page'),
      ),
    );
  }

}

/// https://mp.weixin.qq.com/s/eSVoyITisYYVqQI65agxxQ
class SearchBarDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => '手机号或三省号';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length == 0) {
      return Text('请输入搜索关键字!');
    }

    return Container(
      width: 100.0,
      height:100.0,
      child: Card(
        color:Colors.redAccent,
        child: Center(
          child: Text(query,style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('提示');
  }


  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
        primaryColor: theme.scaffoldBackgroundColor,
        primaryColorBrightness: theme.brightness);

//    assert(context != null);
//    final ThemeData theme = Theme.of(context);
//    assert(theme != null);
//    return theme.copyWith(
//      primaryColor: Colors.white,
//      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
//      primaryColorBrightness: Brightness.light,
//      primaryTextTheme: theme.textTheme,
//    );
  }

  @override
  void close(BuildContext context, result) {

    super.close(context, result);
  }

}

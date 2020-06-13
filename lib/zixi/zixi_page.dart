import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ape/common/widget/my_app_bar.dart';
import 'package:ape/global/global_router.dart';
import 'package:ape/common/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 自习 页面
///
class ZixiPage extends StatefulWidget {
  @override
  _ZixiPageState createState() => _ZixiPageState();
}

class _ZixiPageState extends State<ZixiPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 为实现 AutomaticKeepAliveClientMixin 的功能所必须

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                RefreshHelper(loadData: ({int pageNum, int pageSize}) {
                  //print('lalalalalala   pageNum=$pageNum;pageSize=$pageSize');
                  var num = pageNum ?? 0;

                  List<String> list = [];

                  for (int i = 0; i < pageSize; i++) {
                    list.add('pageNum=$pageNum;pageSize=$pageSize');
                  }
                  return Future.value(list);
                })),
      ],
      child: _main(),
    );
  }

  Widget _main() {
    return Consumer<RefreshHelper>(builder: (context, refreshHelper, _) {
      return Scaffold(
        appBar: MyAppBar(
          centerTitle: '自习',
          actionName: '记录',
          isBack: false,
          onPressed: () {
            NavigatorUtils.push(context, GlobalRouter.writing);
          },
        ),
        body: RefreshConfiguration.copyAncestor(
          context: context,
          headerTriggerDistance:
              80 + MediaQuery.of(context).padding.top / 3, // 触发下拉刷新的距离
          child: SmartRefresher(
            controller: refreshHelper.refreshController,
            header: WaterDropHeader(),
            footer: ClassicFooter(),
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await refreshHelper.refresh();
              setState(() {});
            },
            onLoading: () async {
              await refreshHelper.loadMore();
              setState(() {});
            },
            child: CustomScrollView(
              //controller:,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Text(
                        refreshHelper.dataList[index],
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      );
                    },
                    childCount: refreshHelper.dataList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

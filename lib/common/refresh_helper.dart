import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef Future<List<T>> LoadData<T>({int pageNum,int pageSize});

/// 列表刷新帮助类
class RefreshHelper<T>  with ChangeNotifier {

  // 是否忙碌
  bool _busy = false;

  set busy(bool busy) {
    this._busy = busy;
    notifyListeners();
  }

  // 数据列表
  List<T> dataList = [];

  // 首页编号
  int firstPageNum = 0;

  // 每页数量
  int pageSize = 20;

  LoadData loadData;

  // 刷新控制器
  RefreshController refreshController = RefreshController(initialRefresh: false);

  /// 当前页码
  int _currentPageNum;

  RefreshHelper({@required this.loadData,this.firstPageNum:0, this.pageSize:20}) {
    _currentPageNum = _currentPageNum;
    refresh();
  }

  // 加载数据
  //Future<List<T>> loadData({int pageNum});

  /// 下拉刷新
  Future refresh() async {
    busy = true;
    try {
      _currentPageNum = firstPageNum;
      List<T> data = await loadData(pageNum: firstPageNum, pageSize: pageSize);
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        dataList.clear();
      } else {
        dataList.clear();
        dataList.addAll(data);
        refreshController.refreshCompleted();
        // 小于分页的数量,禁止上拉加载更多
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
      }
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      //dataList.clear();
      refreshController.refreshFailed();
    }
    busy = false;
    notifyListeners();
  }

  /// 上拉加载更多
  Future loadMore() async {
    busy = true;
    try {
      List<T> data = await loadData(pageNum: ++_currentPageNum, pageSize: pageSize);
      if (data.isEmpty) {
        _currentPageNum--;
        refreshController.loadNoData();
      } else {
        dataList.addAll(data);
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
    } catch (e, s) {
      _currentPageNum--;
      refreshController.loadFailed();
    }
    busy = false;
    notifyListeners();
  }
}

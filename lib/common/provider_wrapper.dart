import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider 封装类
///
/// 方便数据初始化
class ProviderWrapper<T extends ChangeNotifier> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;     // Lvvv : typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value, Widget child);
  final T model;
  final Widget child;
  final Function(T model) onModelReady;    // Lvvv : Function 是函数类型
  final bool autoDispose;

  ProviderWrapper({
    Key key,
    @required this.builder,
    @required this.model,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  _ProviderWrapperState<T> createState() => _ProviderWrapperState<T>();
}

class _ProviderWrapperState<T extends ChangeNotifier>
    extends State<ProviderWrapper<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);    // Lvvv : ?. 功能与 . 一致，区别在于左操作数为空不会导致异常
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class ProviderWrapper2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget child)
      builder;
  final A model1;
  final B model2;
  final Widget child;
  final Function(A model1, B model2) onModelReady;
  final bool autoDispose;

  ProviderWrapper2({
    Key key,
    @required this.builder,
    @required this.model1,
    @required this.model2,
    this.child,
    this.onModelReady,
    this.autoDispose,
  }) : super(key: key);

  _ProviderWrapperState2<A, B> createState() => _ProviderWrapperState2<A, B>();
}

class _ProviderWrapperState2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends State<ProviderWrapper2<A, B>> {
  A model1;
  B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      model1.dispose();
      model2.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<A>.value(value: model1),
          ChangeNotifierProvider<B>.value(value: model2),
        ],
        child: Consumer2<A, B>(
          builder: widget.builder,
          child: widget.child,
        ));
  }
}

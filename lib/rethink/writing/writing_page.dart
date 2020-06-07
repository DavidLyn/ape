import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:ape/rethink/writing/extend_textfield/my_special_text_span_builder.dart';
import 'package:ape/common/constants.dart';
import 'package:ape/emoji/emoji_widget.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:ape/util/other_utils.dart';

/// 反思之 书写 页面
class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  // 从 shared preference 中读取键盘高度
  double _softKeyHeight =
      FlutterStars.SpUtil.getDouble(SpConstants.keyboardHeight, defValue: 200);

  // 已选中图片文件列表
  List<File> fileList = List();

  // 当前选中的图片文件
  File selectedFile;

  // 细节输入域控制器
  TextEditingController _detailController = new TextEditingController();

  // 细节输入域的焦点
  FocusNode focusNode = FocusNode();

  // 细节输入域特殊字符处理器
  MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();

  // 表情布局是否已显示
  bool isEmojiLayoutShow = false;

  // 底部布局是否已显示
  bool isBottomLayoutShow = false;

  // 创建键盘是否可见监听器
  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();

  @override
  void initState() {
    super.initState();

    _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        if (visible) {
          isEmojiLayoutShow = false;

          if (!isBottomLayoutShow) {
            setState(() {
              isBottomLayoutShow = true;
            });
          }
        } else {
          if (!isEmojiLayoutShow) {
            setState(() {
              isBottomLayoutShow = false;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _detailController.dispose();
    _keyboardVisibility.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 将刚选中的图片放置到列表中
    if (selectedFile != null) {
      fileList.add(selectedFile);
    }
    selectedFile = null;

    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _writingTitle(),
              _writingDetail(),
              _bottomLayout(),
            ],
          ),
        ),
        onWillPop: () {
          // To-do  。。。。。。。

          return Future.value(false); // do not exit
        },
      ),
    );
  }

  Widget _writingTitle() {
    return Container(
      color: Color(0xFFFAFAFA),
      height: 55.0,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('取消',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                children: <Widget>[
                  Text('记录',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('就是力量',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // To-do 保存数据
                OtherUtils.showToastMessage('保存数据');
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 15.0),
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFFFF8200)),
                child: Text('保存',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _writingDetail() {
    var gridCount;

    if (fileList.length == 0) {
      gridCount = 0;
    } else if (fileList.length > 0 && fileList.length < 9) {
      gridCount = fileList.length + 1;
    } else {
      gridCount = fileList.length;
    }

    return Expanded(
      child: ListView(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(top: 10.0, left: 10.0, right: 10, bottom: 20),
            constraints: BoxConstraints(minHeight: 50.0),
            child: ExtendedTextField(
              specialTextSpanBuilder: _mySpecialTextSpanBuilder,
              controller: _detailController,
              maxLines: 5,
              focusNode: focusNode,
              style: TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration.collapsed(
                  hintText: "记录就是力量",
                  hintStyle: TextStyle(color: Color(0xff919191), fontSize: 15)),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (isBottomLayoutShow) {
                  isBottomLayoutShow = false;
                  isEmojiLayoutShow = false;
                  _hideSoftKey();
                }
              });
            },
            child: GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 3,
              children: List.generate(gridCount, (index) {
                var content;

                if (index == fileList.length) {
                  // 创建添加图片按钮
                  var addCell = Center(
                      child: Image.asset(
                    'assets/images/common/add_image.png',
                    width: double.infinity,
                    height: double.infinity,
                  ));

                  content = GestureDetector(
                    child: addCell,
                    onTap: () {
                      // 如果已添加了9张图片，则提示不允许添加更多
                      var size = fileList.length;
                      if (size >= 9) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("最多只能添加9张图片！"),
                        ));
                        return;
                      }
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((result) {
                        setState(() {
                          selectedFile = result;
                        });
                      });
                    },
                  );
                } else {
                  // 创建被选中的图片,以及左上角的删除图标
                  content = Stack(
                    children: <Widget>[
                      Center(
                        child: Image.file(
                          fileList[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            fileList.removeAt(index);
                            selectedFile = null;
                            setState(() {});
                          },
                          child: Image.asset(
                            'assets/images/common/delete_image.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 80.0,
                  height: 80.0,
                  color: const Color(0xFFffffff),
                  child: content,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // 底部布局
  Widget _bottomLayout() {
    return Column(
      children: <Widget>[
        Container(
          color: Color(0xffF9F9F9),
          padding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              // 选择图片按钮
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/select_image.webp',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((result) {
                      setState(() {
                        selectedFile = result;
                      });
                    });
                  },
                ),
              ),

              // @ 按钮
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/at_others.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    // To-do .......
                    OtherUtils.showToastMessage('@ is tapped!');
                  },
                ),
              ),

              // 选择主题按钮
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/select_topic.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    // To-do .......
                    OtherUtils.showToastMessage('# is tapped!');
                  },
                ),
              ),

              // 选择 gif
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/select_gif.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    // To-do .......
                    OtherUtils.showToastMessage('Gif is tapped!');
                  },
                ),
              ),

              // 选择表情
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/select_emotion.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    setState(() {
                      if (isEmojiLayoutShow) {
                        isBottomLayoutShow = true;
                        isEmojiLayoutShow = false;
                        _showSoftKey();
                      } else {
                        isBottomLayoutShow = true;
                        isEmojiLayoutShow = true;
                        _hideSoftKey();
                      }
                    });
                  },
                ),
              ),

              //
              Expanded(
                child: InkWell(
                  child: Image.asset(
                    'assets/images/common/select_add.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onTap: () {
                    // To-do .......
                    OtherUtils.showToastMessage('+ is tapped!');
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isBottomLayoutShow,
          child: Container(
            height: _softKeyHeight,
            child: Visibility(
              visible: isEmojiLayoutShow,
              child: EmojiWidget(
                onEmojiClockBack: (value) {
                  if (value == 0) {
                    _detailController.clear();
                  } else {
                    _detailController.text =
                        _detailController.text + "[/" + value.toString() + "]";
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSoftKey() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _hideSoftKey() {
    focusNode.unfocus();
  }

}

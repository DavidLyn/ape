import 'package:flutter/material.dart';

import 'package:keyboard_actions/keyboard_action.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import 'package:oktoast/oktoast.dart';

import 'package:ape/util/theme_utils.dart';

class OtherUtils {

  static KeyboardActionsConfig getKeyboardActionsConfig(BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: ThemeUtils.getKeyboardActionsColor(context),
      nextFocus: true,
      actions: List.generate(list.length, (i) => KeyboardAction(
        focusNode: list[i],
        toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: const Text('关闭'),
              ),
            );
          },
        ],
      )),
    );
  }

  static showToastMessage(String msg, {duration = 2000}) {
    if (msg == null) {
      return;
    }
    showToast(
        msg,
        duration: Duration(milliseconds: duration),
        dismissOtherToast: true
    );
  }

  static cancelToast() {
    dismissAllToast();
  }

}
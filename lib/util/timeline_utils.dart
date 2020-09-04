import 'package:common_utils/common_utils.dart';

/// 时间线工具类
class TimelineUtils {

  static const String myLocale = 'myLocale';

  static void init() {
    setLocaleInfo(myLocale,ZhInfo());
  }

  static String format(int ms, int locTimeMs) {
    return TimelineUtil.format(ms, locTimeMs: locTimeMs, locale: myLocale);
  }

  static String formatByDatetime(DateTime ms, DateTime locTimeMs) {
    if (ms == null || locTimeMs == null)
      return '';

    return TimelineUtil.format(ms.millisecondsSinceEpoch, locTimeMs: locTimeMs.millisecondsSinceEpoch, locale: myLocale);
  }

}

import 'package:intl/intl.dart';

class Utils {

  // TIME FORMATTER
  static const SECOND_MILLIS = 1000;
  static const MINUTE_MILLIS = 60 * SECOND_MILLIS;
  static const HOUR_MILLIS = 60 * MINUTE_MILLIS;
  static const DAY_MILLIS = 24 * HOUR_MILLIS;

  String _calculatedTime = "";

  String? getTimeAgo(int time) {
  var now = DateTime.now().millisecondsSinceEpoch;
  if (time > now || time <= 0) {
    return _calculatedTime;
  }

  final diff = now - time;

  if (diff < MINUTE_MILLIS) {
    _calculatedTime = "Now";
  } else if (diff < 2 * MINUTE_MILLIS) {
    _calculatedTime = "1 min";
  } else if (diff < 50 * MINUTE_MILLIS) {
    _calculatedTime = (diff ~/ MINUTE_MILLIS).toString() + " min";
  } else if (diff < 90 * MINUTE_MILLIS) {
    _calculatedTime = "1h";
  } else if (diff < 24 * HOUR_MILLIS) {
    _calculatedTime = (diff ~/ HOUR_MILLIS).toString() + "h";
  } else if (diff < 48 * HOUR_MILLIS) {
    _calculatedTime = "y";
  } else {
    _calculatedTime = (diff ~/ DAY_MILLIS).toString() + " d";
  }

  print(_calculatedTime);

  return _calculatedTime;
}


  // FOLLOWERS, POSTS, FOLLOWING COUNT FORMATTER

  String getFormattedCounts(int count) {

    var countFormat = NumberFormat.compact();
    return countFormat.format(count).toString();
  }

}
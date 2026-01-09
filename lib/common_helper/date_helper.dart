import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static final int secondMillis = 1000;
  static final int minuteMillis = 60 * secondMillis;
  static final int hourMillis = 60 * minuteMillis;
  static final int dayMillis = 24 * hourMillis;
  static final int weekMillis = 7 * dayMillis;

  static const _isoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static final _isoFormatter = DateFormat(_isoFormat);

  static final _timeFormat12 = DateFormat("hh:mm a");
  static final _timeFormat24 = DateFormat("HH:mm:ss");

  static final _dateFormatDob = DateFormat("yyyy-MM-dd");
  static final _getYear = DateFormat("yyyy");
  static final _dateFormatDob1 = DateFormat("yyyy/MM/dd");
  static final _dateFormatDobNew = DateFormat("dd-MM-yyyy");
  static final _dateFormatRenew = DateFormat("dd MMM, yyyy");
  static final _dateFormatGoal = DateFormat("dd/MM/yyyy");
  static final _dateFormatPlan = DateFormat("MMMM yyyy");
  static final _dateFormat = DateFormat("dd/MM/yyyy");
  static final _eventDateForBackend = DateFormat("yyyy-MM-dd HH:mm:ss");

  static String getTime12Hours(DateTime? dateTime) {
    if (dateTime == null) return "";
    return _timeFormat12.format(dateTime);
  }

  static String getCurrentDateTimeIso() {
    DateTime now = DateTime.now();
    return _isoFormatter.format(now);
  }

  static String getDateTimeIso(DateTime dateTime) {
    return _isoFormatter.format(dateTime);
  }

  static String getDOB(DateTime dateTime) {
    return _dateFormatDob.format(dateTime);
  }

  static String getDOBNew(DateTime dateTime) {
    return _dateFormatDobNew.format(dateTime);
  }

  static String getGoal(DateTime dateTime) {
    return _dateFormatGoal.format(dateTime);
  }

  static String getDate(String dateTime) {
    return _dateFormatDobNew.format(_dateFormatDob.parse(dateTime));
  }
  static String getDateRenew(String dateTime) {
    return _dateFormatRenew.format(_dateFormatDob.parse(dateTime));
  }
  static String getDate1(String dateTime) {
    return _dateFormatDob.format(_dateFormatDob.parse(dateTime));
  }
  static String getDate2(String dateTime) {
    return _dateFormatDob1.format(_dateFormatDob.parse(dateTime));
  }

  static String getPlanDate(String dateTime) {
    if (dateTime.isEmpty) {
      return "";
    }
    var input = _dateFormatDob.parse(dateTime);
    var day = "";
    if (input.day > 4) {
      day = "${input.day}th";
    } else if (input.day == 3) {
      day = "${input.day}rd";
    } else if (input.day == 2) {
      day = "${input.day}nd";
    } else if (input.day == 1) {
      day = "${input.day}st";
    }
    return "$day ${_dateFormatPlan.format(_dateFormatDob.parse(dateTime))}";
  }

  static String getNewDate(DateTime? dateTime) {
    if (dateTime == null) return "";
    return _dateFormatDobNew.format(dateTime);
  }

  static DateTime getDateTime(String date) {
    return _dateFormatDob.parse(date, false);
  }

  static DateTime getDateInDate(String date) {
    return _dateFormatDob.parse(date, false);
  }

  static String getAge(DateTime dateTime){
    var now = DateTime.now();
    var age = now.year - dateTime.year;
    return age.toString();
  }

  static String getAgeFromStringDate(String? dateTime){
    if(dateTime == null){
      return "";
    }
    var now = DateTime.now();
    var age = now.year - getDateInDate(dateTime).year;
    return age.toString();
  }

  static String getDobBackend(String dateTime) {
    return _dateFormatDob.format(_dateFormatDobNew.parse(dateTime));
  }


  static calculateAge(String? birthDate) {
    if (birthDate == null){
      return "";
    }
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - getDateInDate(birthDate).year;
    int month1 = currentDate.month;
    int month2 =  getDateInDate(birthDate).month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 =  getDateInDate(birthDate).day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  static getYear(String dateTime) {
    return _getYear.format(_dateFormatDob.parse(dateTime));
  }


  static DateTime getUtcTime(String? dateTimeString){
    return _isoFormatter.parse(dateTimeString!, true);
  }


  static String getDateNew(DateTime? date) {
    if (date == null) return "";
    return _dateFormat.format(date);
  }

  static String getProjectDate(String? date) {
    if (date == null) return "";
    return _dateFormat.format(getUtcTime(date));
  }

  static String getTimeAgo(String? dateTimeString) {
    if(dateTimeString == null){
      return "";
    }
    var dateTime = _isoFormatter.parse(dateTimeString, true);
    return getTimeAgoInt(dateTime.millisecondsSinceEpoch);
  }

  static String getTimeAgoInt(int time) {
    if (time < 1000000000000) {
      // if timestamp given in seconds, convert to millis
      time *= 1000;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    if (time > now || time <= 0) {
      return "just now";
    }
    // TODO: localize
    final int diff = now - time;
    if (diff < minuteMillis) {
      return "just now";
    } else if (diff < 2 * minuteMillis) {
      return "a minute ago";
    } else if (diff < 50 * minuteMillis) {
      return "${(diff / minuteMillis).floor()} minutes ago";
    } else if (diff < 90 * minuteMillis) {
      return "an hour ago";
    } else if (diff < 24 * hourMillis) {
      return "${(diff / hourMillis).floor()} hours ago";
    } else if (diff < 48 * hourMillis) {
      return "yesterday";
    } else if (diff < 9 * dayMillis){
      return "${(diff / dayMillis).floor()} days ago";
    } else {
      return "${(diff / weekMillis).floor()} weeks ago";
    }
  }

  static String getDayAgo(String? dateTimeString) {
    if(dateTimeString == null){
      return "";
    }
    var dateTime = _isoFormatter.parse(dateTimeString, true);
    return getDayAgoInt(dateTime.millisecondsSinceEpoch);
  }

  static String getDayAgoInt(int time) {
    if (time < 1000000000000) {
      // if timestamp given in seconds, convert to millis
      time *= 1000;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    if (time > now || time <= 0) {
      return "just now";
    }
    // TODO: localize
    final int diff = now - time;
    if (diff < 24 * hourMillis) {
      return "Today";
    } else if (diff < 48 * hourMillis) {
      return "Yesterday";
    } else if (diff < 9 * dayMillis){
      return "${(diff / dayMillis).floor()} days ago";
    } else {
      return "${(diff / weekMillis).floor()} weeks ago";
    }
  }

  static bool isFutureDate(DateTime? dateTime) {
    if(dateTime == null){
      return false;
    }
    return DateTime.now().isBefore(dateTime);
  }

  static String combineEventDateAndTimeBackend(
      DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) {
      return '';
    }
    DateTime combineDateTime =
    DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return _eventDateForBackend.format(combineDateTime);
  }

  static String formatChatTime(String isoString) {
    if (isoString.trim().isNotEmpty) {
      DateTime dateTime = DateTime.parse(isoString);
      DateFormat formatter = DateFormat('h:mm a');
      return formatter.format(dateTime.toLocal());
    }
    else {
      return "";
    }
  }

  static DateTime addMonths(DateTime dateTime, int months) {
    if (dateTime.isUtc) {
      return DateTime.utc(dateTime.year, dateTime.month + months, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    } else {
      return DateTime(dateTime.year, dateTime.month + months, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    }
  }

  static DateTime addYear(DateTime dateTime, int year) {
    if (dateTime.isUtc) {
      return DateTime.utc(dateTime.year+year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    } else {
      return DateTime(dateTime.year+year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    }
  }
}

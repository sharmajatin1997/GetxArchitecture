import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class SharedPreferenceHelper {
  static late GetStorage getStorage;

  static const String _userToken = "userToken";
  static const String _languageCode = "languageCode";

  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  SharedPreferenceHelper._internal() {
    getStorage;
  }

  static Future<GetStorage?> init() async {
    await GetStorage.init("UBSold");
    getStorage = GetStorage("UBSold");
    return getStorage;
  }

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  _savePref(String key, Object? value) async {
    var prefs = getStorage;
    if (prefs.hasData(key)) {
      prefs.remove(key);
    }
    if (value is bool) {
      return prefs.write(key, value);
    } else if (value is int) {
      return prefs.write(key, value);
    } else if (value is String) {
      return prefs.write(key, value);
    } else if (value is double) {
      return prefs.write(key, value);
    }
  }

  T? _getPref<T>(String key) {
    final value = getStorage.read(key);
    if (value == null) return null;
    return value as T;
  }

  void clearAll() {
    getStorage.erase();
  }

  String? getUserToken() {
    return _getPref(_userToken);
  }

  void saveUserToken(String? token) {
    _savePref(_userToken, token);
  }

  String getLanguageCode() {
    final code = _getPref<String>(_languageCode);
    if (code == null) {
      saveLanguageCode("en_US");
      return "en_US";
    }
    return code;
  }

  void saveLanguageCode(String? code) => _savePref(_languageCode, code);
}

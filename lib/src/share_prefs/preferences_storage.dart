import 'package:shared_preferences/shared_preferences.dart';

class PreferenceStorage {
  static final PreferenceStorage _instancia = new PreferenceStorage._internal();

  factory PreferenceStorage() {
    return _instancia;
  }
  PreferenceStorage._internal();
  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String getValue({String key}) {
    return this._prefs.getString(key);
  }

  Future<bool> setValue({String key, String value}) async {
    return await this._prefs.setString(key, value);
  }

  Future<bool> deleteValue({String key}) async {
    return await this._prefs.remove(key);
  }
}

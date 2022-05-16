import 'shared_preferences_storage.dart';

class NotificationsStorage extends SharedPreferencesStorage {
  static const _dateKey = 'date';
  static const _timeKey = 'time';

  Future saveDate(String date) {
    return preferences.then((prefs) => prefs.setString(_dateKey, date));
  }

  Future<String> getDate() async {
    return preferences.then((prefs) => prefs.getString(_dateKey) ?? '');
  }

  Future saveTime(String time) {
    return preferences.then((prefs) => prefs.setString(_timeKey, time));
  }

  Future<String> getTime() async {
    return preferences.then((prefs) => prefs.getString(_timeKey) ?? '');
  }

  Future<void> clearNotification() async {
    return preferences.then((prefs) {
      prefs.remove(_dateKey);
      prefs.remove(_timeKey);
    });
  }

}
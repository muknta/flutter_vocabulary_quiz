import 'package:vocabulary_quiz/data/db/dao/settings_dao.dart';


class SettingsDaoModule {
  static SettingsDao _settingsDao;

  static SettingsDao settingsDao() {
    if (_settingsDao == null) {
      _settingsDao = SettingsDao();
    }
    return _settingsDao;
  }
}

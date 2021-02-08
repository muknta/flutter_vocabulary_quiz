import 'package:sembast/sembast.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/data/db/sembast_db.dart';
import 'package:vocabulary_quiz/data/db/exceptions.dart';
import 'package:vocabulary_quiz/domain/model/setting.dart';


class SettingsDao {
  // final _settingsFolder = intMapStoreFactory.store(Config.settingsFolderName);
  final _settingsStore = StoreRef<String, dynamic>.main();

  Database get _db => locator<Database>();

  Future<bool> insertSetting(Setting setting) async {
    try {
      final Map<String, dynamic> _map = await getAllSettings();
      final Map<String, dynamic> _settings = _map['data'];
      _settings[setting.title] = setting.value;
      await updateAllSettings(_settings);

      return true;
    } on InsertingException {
      print('InsertingException');
    }
    return false;
  }

  Future<bool> updateSetting({
    @required Setting setting,
  }) async {
    try {

      print('settingTitle ${setting.title} ${setting.value}');
      final Map<String, dynamic> _map = await getAllSettings();
      final Map<String, dynamic> _settings = _map['data'];
      _settings.update(
        setting.title,
        (_) => setting.value);
      await updateAllSettings(_settings);

      return true;
    } on UpdatingException {
      print('UpdatingException');
    }
    return false;
  }

  Future<bool> updateAllSettings(
    @required Map<String, dynamic> settings,
  ) async {
    try {
      await _settingsStore.record(Config.settingsRecordName)
              .update(_db, settings);
      print('Settings updated');

      return true;
    } on UpdatingException {
      print('UpdatingException');
    }
    return false;
  }

  Future<bool> deleteSetting(String settingTitle) async {
    try {
      final Map<String, dynamic> _map = await getAllSettings();
      final Map<String, dynamic> _settings = _map['data'];
      dynamic _removedValue = _settings.remove(settingTitle);
      await updateAllSettings(_settings);
      print('Setting deleted - ${settingTitle}: $_removedValue');

      return true;
    } on DeletingException {
      print('DeletingException');
    }
    return false;
  }

  Future<Map<String, dynamic>> getSetting(String settingTitle) async {
    dynamic _settingValue;
    bool _result = false;
    Setting _setting;
    try {
      print('settingTitle $settingTitle');
      final Map<String, dynamic> _map = await getAllSettings();
      final Map<String, dynamic> _settings = _map['data'];
      _settingValue = _settings[settingTitle];
      _setting = Setting(
          title: settingTitle,
          value: _settingValue,
        );
      print("Setting - ${_setting.title}: ${_setting.value}");

      _result = true;
    } on ReadingException {
      print('ReadingException');
    }
    return {
      'result': _result,
      'data': _setting,
    };
  }

  Future<Map<String, dynamic>> getAllSettings() async {
    bool result = false;
    Map<String, dynamic>_settings;
    try {
      _settings = await _settingsStore.record(Config.settingsRecordName).get(_db);

      result = true;
    } on ReadingException {
      print('ReadingException');
    }
    return {
      'result': result,
      'data': _settings,
    };
  }

  Future<void> deleteAllSettings() async {
    await _settingsStore.record(Config.settingsRecordName).delete(_db);
  }
}

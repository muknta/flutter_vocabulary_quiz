import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:vocabulary_quiz/data/config.dart';


class SembastDB {
  Completer<Database> _dbOpenCompleter;
  String _dbPath;

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future<void> _openDatabase() async {
    _dbPath ??= await _getDBPath();
    final database = await databaseFactoryIo.openDatabase(_dbPath);

    _dbOpenCompleter.complete(database);
  }

  Future<void> _deleteDatabase() async {
    _dbPath ??= await _getDBPath();
    await databaseFactoryIo.deleteDatabase(_dbPath);
  }

  Future<String> _getDBPath() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _dbPath = join(appDocumentDir.path, Config.sembastDBName);
    return _dbPath;
  }
}
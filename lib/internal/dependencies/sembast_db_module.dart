import 'package:vocabulary_quiz/data/db/sembast_db.dart';


class SembastDBModule {
  static SembastDB _sembastDB;

  static SembastDB sembastDB() {
    if (_sembastDB == null) {
      _sembastDB = SembastDB();
    }
    return _sembastDB;
  }
}

import 'package:vocabulary_quiz/data/db/dao/word_dao.dart';


class WordDaoModule {
  static WordDao _wordDao;

  static WordDao wordDao() {
    if (_wordDao == null) {
      _wordDao = WordDao();
    }
    return _wordDao;
  }
}

import 'package:vocabulary_quiz/data/repository/vocabulary_data_repository.dart';
import 'word_dao_module.dart';
import 'settings_dao_module.dart';


class VocabularyDataRepositoryModule {
  static VocabularyDataRepository _vocabularyDataRepository;

  static VocabularyDataRepository vocabularyDataRepository() {
    if (_vocabularyDataRepository == null) {
      _vocabularyDataRepository = VocabularyDataRepository(
        wordDao: WordDaoModule.wordDao(),
        settingsDao: SettingsDaoModule.settingsDao(),
      );
    }
    return _vocabularyDataRepository;
  }
}

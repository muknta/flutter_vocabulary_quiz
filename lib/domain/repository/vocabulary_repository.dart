import 'package:meta/meta.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


abstract class VocabularyRepository {
  Future<List<Word>> getAllWords();

  Future<bool> deleteWord(Word _word);

  Future<bool> uploadTestSet();

  Future<bool> insertWord({
    int primaryKey,
    @required String word,
    @required List<String> translateList,
    String imagePath,
    bool isPassed,
    bool doesSelectedOnce,
  });

  Future<List<Word>> generateQuizWords();

  Future<List<Word>> getNRandomRecordsExceptWord({
    @required Word word,
    int itemsNum,
  });

  Future<bool> checkIfWordUnique(String word);

  Future<bool> updateTranslateList({
    @required Word word,
    @required List<String> newTranslateList,
  });

  Future<bool> updateBoolStatuses({
    @required Word word,
    @required bool isPassed,
    @required bool doesSelectedOnce,
  });

  Future<bool> setFromOriginal({
    @required bool fromOriginal,
  });

  Future<void> deleteAllRecords();
}

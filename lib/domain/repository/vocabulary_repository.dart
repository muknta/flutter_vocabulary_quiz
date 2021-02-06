import 'package:meta/meta.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


abstract class VocabularyRepository {
  Future<List<Word>> getAllWords();

  Future<bool> deleteWord(Word _word);

  Future<bool> uploadTestSet();

  Future<int> insertWord({
    @required String word,
    @required List<String> translateList,
    String imagePath,
    bool isPassed,
    bool doesSelectedOnce,
  });

  Future<List<Word>> generateQuizWords();

  Future<List<Word>> generateQuizVariantsOf(Word _word);

  Future<bool> updateTranslateList({
    @required Word word,
    @required List<String> newTranslateList,
  });

  Future<bool> updatePassingStatus({
    @required Word word,
    @required bool newIsPassed,
  });

  Future<bool> updateVirginStatus({
    @required Word word,
    @required bool newDoesSelectedOnce,
  });

  Future<void> deleteRecords();
}

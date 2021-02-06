import 'dart:async';

import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/data/db/word_dao.dart';
import 'package:vocabulary_quiz/data/db/vocabulary_filling_up.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
// import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/domain/repository/vocabulary_repository.dart';


class VocabularyDataRepository extends VocabularyRepository {
  VocabularyDataRepository({
    @required this.wordDao,
  }) : assert(wordDao != null);

  final WordDao wordDao;

  @override
  Future<List<Word>> getAllWords() async {
    Map<String, dynamic> response = await wordDao.getAllWords();
    return response['data'];
  }

  @override
  Future<bool> deleteWord(Word _word) async {
    return await wordDao.deleteWord(_word);
  }

  @override
  Future<bool> uploadTestSet() async {
    return await VocabularyFillingUp.fillingUp();
  }

  @override
  Future<List<Word>> generateQuizWords() async {
    var response = await wordDao.boolFilterWords();
    print('response - $response');
    // List<Word> _quizWords = _chooseQuizWordsFromAllWords(response['data']);
    // return _quizWords;
    return [];
  }

  List<Word> _chooseQuizWordsFromAllWords(List<Word> _allWords) {
    List<Word> _quizWords = [];

    _quizWords = _chooseWhichWhereNotUsed(
        allWords: _allWords,
        quizWords: _quizWords,
      );
    if (_quizWords.length == Config.quizWordsNum) {
      return _quizWords;
    } else {
      _quizWords = _chooseWhichWhereNotPassed(
          allWords: _allWords,
          quizWords: _quizWords,
        );
    }
    if (_quizWords.length == Config.quizWordsNum) {
      return _quizWords;
    } 
    // else {
    //   _quizWords = _chooseWhichPassed(
    //       allWords: _allWords,
    //       quizWords: _quizWords,
    //     );
    // }
    
  }

  List<Word> _chooseWhichWhereNotUsed({
    List<Word> allWords,
    List<Word> quizWords,
  }) {
    for (Word _word in allWords) {
      if (quizWords.length == Config.quizWordsNum) {
        return quizWords;
      }
      if (!_word.isPassed && !_word.doesSelectedOnce) {
        quizWords.add(_word);
      }
    }
    return quizWords;
  }

  List<Word> _chooseWhichWhereNotPassed({
    List<Word> allWords,
    List<Word> quizWords,
  }) {
    for (Word _word in allWords) {
      if (quizWords.length == Config.quizWordsNum) {
        return quizWords;
      }
      if (!_word.isPassed && _word.doesSelectedOnce) {
        quizWords.add(_word);
      }
    }
    return quizWords;
  }

  @override
  Future<List<Word>> generateQuizVariantsOf(Word _word) async {
    Map<String, dynamic> response = await wordDao.getAllWords();
    return response['data'];
  }

  @override
  Future<bool> insertWord({
    int primaryKey,
    @required String word,
    @required List<dynamic> translateList,
    String imagePath = Config.defaultImageLocalPath,
    bool isPassed = false,
    bool doesSelectedOnce = false,
  }) async {
    return await wordDao.insertWord(
      Word(
        primaryKey: primaryKey,
        word: word,
        translateList: translateList,
        imagePath: imagePath,
        isPassed: isPassed,
        doesSelectedOnce: doesSelectedOnce,
      )
    );
  }

  @override
  Future<bool> updateTranslateList({
    @required Word word,
    @required List<String> newTranslateList,
  }) async {
    Word newWord = word.copyWith(
      translateList: newTranslateList);

    return await wordDao.updateWord(
      newWord: newWord,
      oldWord: word,
    );
  }

  @override
  Future<bool> updatePassingStatus({
    @required Word word,
    @required bool newIsPassed,
  }) async {
    Word newWord = word.copyWith(isPassed: newIsPassed);

    return await wordDao.updateWord(
      newWord: newWord,
      oldWord: word,
    );
  }

  @override
  Future<bool> updateVirginStatus({
    @required Word word,
    @required bool newDoesSelectedOnce,
  }) async {
    Word newWord = word.copyWith(
      doesSelectedOnce: newDoesSelectedOnce);

    return await wordDao.updateWord(
      newWord: newWord,
      oldWord: word,
    );
  }

  @override
  Future<void> deleteRecords() async {
    await wordDao.deleteRecords();
  }
}

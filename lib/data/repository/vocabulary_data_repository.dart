import 'dart:async';
import 'dart:math' show Random;
import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/data/db/dao/word_dao.dart';
import 'package:vocabulary_quiz/data/db/dao/settings_dao.dart';
import 'package:vocabulary_quiz/data/db/vocabulary_filling_up.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
import 'package:vocabulary_quiz/domain/model/setting.dart';
// import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/domain/repository/vocabulary_repository.dart';


class VocabularyDataRepository extends VocabularyRepository {
  VocabularyDataRepository({
    @required this.wordDao,
    @required this.settingsDao,
  })  : assert(wordDao != null),
        assert(settingsDao != null);

  final WordDao wordDao;
  final SettingsDao settingsDao;

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
    List<Word> _wordList = await _getQuizWordsByBool(
      wordsNum: Config.quizWordsNum,
      isPassed: false,
      doesSelectedOnce: false,
    );
    
    if ((_wordList?.length ?? 0) >= Config.quizWordsNum) {
      return _wordList;
    } else {
      int neededLength = Config.quizWordsNum - _wordList?.length ?? 0;
      List<Word> _subList = await _getQuizWordsByBool(
        wordsNum: neededLength,
        isPassed: false,
        doesSelectedOnce: true,
      );
      _wordList.addAll(_subList);
    }
    if ((_wordList?.length ?? 0) >= Config.quizWordsNum) {
      return _wordList;
    } else {
      int neededLength = Config.quizWordsNum - _wordList?.length ?? 0;
      List<Word> _subList = await _getQuizWordsByBool(
        wordsNum: neededLength,
        isPassed: true,
        doesSelectedOnce: true,
      );
      _wordList.addAll(_subList);
    }
    if (_wordList?.isEmpty ?? true) {
      return _wordList;
    }

    List<Word> _resultList = [];
    for (int i = 0; _resultList.length < Config.quizWordsNum; i++) {
      _resultList.add(_wordList.elementAt(i % _wordList.length));
    }
    return _resultList;
  }

  Future<List<Word>> _getQuizWordsByBool({
    @required int wordsNum,
    @required bool isPassed,
    @required bool doesSelectedOnce,
  }) async {
    List<Word> response = await wordDao.boolFilterWords(
          isPassed: isPassed,
          doesSelectedOnce: doesSelectedOnce,
        );
    List<Word> _wordList = [];
    // print('response - $response');
    if (response?.length >= Config.quizWordsNum) {
      _wordList = response.sublist(0, wordsNum);
    } else if (response?.length != 0) {
      _wordList = response.sublist(0);
    }
    return _wordList;
  }

  @override
  Future<List<Word>> getNRandomRecordsExceptWord({
    @required Word word,
    int itemsNum = Config.quizVariantsNum - 1,
  }) async {
    List<Word> _wordList = [];
    bool result = false;
    Random random = new Random();

    Map<String, dynamic> response = await wordDao.getAllWords();
    if (response['result'] ?? false) {
      List<Word> _allWords = response['data'];

      List<int> _randomList = _getRandomList(
            itemsNum, _allWords.length, random);

      _randomList.forEach((int _randInt) {
        Word _word = _allWords.elementAt(_randInt);
        _word.word != word.word
          ? _wordList.add(_word)
          : _wordList.add(
              _allWords.elementAt(
                _getDifferentRandInt(
                  _randomList, _allWords.length, random,
                )
              )
            );
      });
    }
    _wordList
        ..add(word)
        ..shuffle();
    return _wordList;
  }

  List<int> _getRandomList(
    int itemsNum,
    int maxValue,
    Random random,
  ) {
    List<int> _randomList = new List.generate(
        itemsNum,
        (_) => random.nextInt(maxValue),
      );
    print('_randomList - $_randomList');
    _randomList.toSet().toList();
    while (_randomList.length < itemsNum) {
      _randomList.add(
        _getDifferentRandInt(_randomList, maxValue, random)
      );
    }
    return _randomList;
  }

  int _getDifferentRandInt(
    List<int> _randList,
    int _maxNum,
    Random _random,
  ) {
    if (_maxNum <= (_randList?.length ?? 0)) {
      return 0;
    }
    int _randInt = _random.nextInt(_maxNum);
    while (_randList.contains(_randInt)) {
      _randInt = _random.nextInt(_maxNum);
    }
    return _randInt;
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
  Future<bool> checkIfWordUnique(String word) async {
    return await wordDao.checkIfWordUnique(word);
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
  Future<bool> updateBoolStatuses({
    @required Word word,
    @required bool isPassed,
    @required bool doesSelectedOnce,
  }) async {
    Word newWord = word.copyWith(
      isPassed: isPassed,
      doesSelectedOnce: doesSelectedOnce,
    );

    return await wordDao.updateWord(
      newWord: newWord,
      oldWord: word,
    );
  }

  @override
  Future<bool> setFromOriginal({
    @required bool fromOriginal,
  }) async {
    print('rep fromOriginal $fromOriginal');
    final _setting = Setting(
      title: Config.fromOriginalTitle,
      value: fromOriginal,
    );
    return await settingsDao.updateSetting(
      setting: _setting,
    );
  }

  @override
  Future<void> deleteAllRecords() async {
    await wordDao.deleteAllRecords();
  }
}

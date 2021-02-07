import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:vocabulary_quiz/internal/navigation/navigation.dart';
import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/data/repository/vocabulary_data_repository.dart';
import 'package:vocabulary_quiz/domain/model/global_result.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


class VocabularyBloc {
  VocabularyBloc._init(
    this._vocabularyRepo,
  ) : assert(_vocabularyRepo != null);

  static Future<VocabularyBloc> init(_vocabularyRepo) async {
    VocabularyBloc vocBloc = VocabularyBloc._init(_vocabularyRepo);

    vocBloc._variantActionController
        .stream
        .listen(vocBloc._checkVariant);
    vocBloc._newWordActionController
        .stream
        .listen(vocBloc._addWordToList);

    await vocBloc._updateWordListControll();
    return vocBloc;
  }

  final VocabularyDataRepository _vocabularyRepo;
  int _currQuizWordNum = 0;
  int _errorCounter = 0;
  GlobalResult _globalResult = GlobalResult();
  List<Word> _quizWords = [];
  List<Word> _quizVariants = [];
  List<Word> _allWords = [];

  GlobalResult get globalResult => _globalResult;

  /// Page number in quiz
  int get currQuizWordNum => _currQuizWordNum;
  Word get currQuizWord => _quizWords.isNotEmpty
          ? _quizWords?.elementAt(_currQuizWordNum-1)
          : null;

  /// WordList in home
  final BehaviorSubject<List<Word>> _wordListController = BehaviorSubject();
  Stream get wordListStream => _wordListController.stream;
  Sink get _setWordList => _wordListController.sink;
  /// Add Word with translate in home
  StreamController<Map<String, String>> _newWordActionController = StreamController();
  StreamSink get addWordWithTranslate => _newWordActionController.sink;

  /// Variants in quiz
  final BehaviorSubject<List<Word>> _variantsController = BehaviorSubject();
  Stream get variantsStream => _variantsController.stream;
  Sink get _setVariants => _variantsController.sink;

  /// Single variant in quiz
  final BehaviorSubject<bool> _variantResultController = BehaviorSubject();
  Stream get variantResultStream => _variantResultController.stream;
  Sink get _setVariantResult => _variantResultController.sink;
  /// 
  StreamController<Word> _variantActionController = StreamController();
  StreamSink get checkVariant => _variantActionController.sink;


  /// Word in quiz
  final BehaviorSubject<Word> _quizWordController = BehaviorSubject();
  Stream get quizWordStream => _quizWordController.stream;
  Sink get _setQuizWord => _quizWordController.sink;

  /// Quiz - from original to translate or vice versa
  final BehaviorSubject<bool> _fromOriginalController = BehaviorSubject();
  Stream get fromOriginalStream => _fromOriginalController.stream;
  Sink get _setFromOriginal => _fromOriginalController.sink;


  Future<void> _updateWordListControll() async {
    _setWordList.add(await _getAllWords());
  }

  Future<List<Word>> _getAllWords() async {
    _allWords = await _vocabularyRepo.getAllWords();
    return _allWords;
  }

  Future<bool> _addWordToList(
    Map<String, String> wordWithTranslate,
  ) async {
    final bool _result = await _vocabularyRepo.insertWord(
        word: wordWithTranslate['word'],
        translateList: [wordWithTranslate['translate']],
      );
    if (_result) {
      await _updateWordListControll();
    }
    return _result;
  }

  Future<bool> onStartQuiz() async {
    _setFromOriginal.add(Config.defaultTranslateFromOriginal);
    _currQuizWordNum = 1;
    bool _result;
    _result = await _generateQuizWords();
    return _result
      ? await _generateQuizVariants()
      : false;
  }

  Future<bool> _nextQuizWord(bool isPassed) async {
    await _vocabularyRepo.updateBoolStatuses(
      word: currQuizWord,
      isPassed: isPassed,
      doesSelectedOnce: true,
    );
    await _updateWordListControll();
    _globalResult.updateErrors(_errorCounter);
    isPassed
      ? _globalResult.incrementSuccesses()
      : _globalResult.incrementFailures();

    _errorCounter = 0;
    if (++_currQuizWordNum > Config.quizWordsNum) {
      _setQuizWord.add(null);
      _setVariants.add(null);

      locator<NavigationService>().navigateTo(
        Routes.result,
        arguments: {
          'global_result': globalResult.copyWith(),
        },
      );
      _globalResult.clearAll();

      _currQuizWordNum = 1;
      return true;
    }
    _setQuizWord.add(currQuizWord);
    
    bool _result = await _generateQuizVariants();
    return _result;
  }

  Future<bool> _generateQuizWords() async {
    _quizWords = await _vocabularyRepo.generateQuizWords();
    if (_quizWords?.isEmpty ?? true) {
      return false;
    }
    _setQuizWord.add(currQuizWord);
    return true;
  }

  Future<bool> _generateQuizVariants() async {
    _quizVariants = await _vocabularyRepo
            .getNRandomRecordsExceptWord(word: currQuizWord);
    if (_quizVariants?.isEmpty ?? true) {
      return false;
    }
    _setVariants.add(_quizVariants);
    return true;
  }

  Future<bool> _checkVariant(Word _variant) async {
    print('_variant?.primaryKey ${_variant?.primaryKey}\ncurrQuizWord.primaryKey ${currQuizWord.primaryKey}');
    print('_variant?.primaryKey ${_variant?.primaryKey == currQuizWord.primaryKey}');
    bool _result = (_variant?.primaryKey == currQuizWord.primaryKey);

    if (_result) {
      Future.delayed(const Duration(
        milliseconds: Config.millisecondsDelayed), () async {
          await _nextQuizWord(_result);
        });
    } else {
      if (++_errorCounter >= Config.maxAttemptsNum) {
        Future.delayed(const Duration(
          milliseconds: Config.millisecondsDelayed), () async {
            await _nextQuizWord(_result);
          });
      }
    }
    _setVariantResult.add(_result);
    Future.delayed(const Duration(
        milliseconds: Config.millisecondsDelayed), () {
          _setVariantResult.add(null);
        });
    return _result;
  }

  Future<bool> checkIfWordUnique(String word) async {
    return await _vocabularyRepo.checkIfWordUnique(word);
  }

  Future<bool> deleteLastWord() async {
    // print('$_allWords');
    bool _result = false;
    if (_allWords?.isNotEmpty ?? false) {
      _result = await _vocabularyRepo.deleteWord(_allWords?.last);

      await _updateWordListControll();
    }
    return _result;
  }

  Future<bool> uploadTestSet() async {
    final _result = await _vocabularyRepo.uploadTestSet();
    await _updateWordListControll();

    return _result;
  }

  Future<void> _deleteAllRecords() async {
    await _vocabularyRepo.deleteAllRecords();
    _setWordList.add(null);
    print('All records are deleted');
  }

  void dispose() {
    _newWordActionController.close();
    _wordListController.close();
    _variantActionController.close();
    _variantsController.close();
    _variantResultController.close();
    _quizWordController.close();
  }
}

import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:vocabulary_quiz/domain/model/word.dart';
import 'package:vocabulary_quiz/data/repository/vocabulary_data_repository.dart';


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
    vocBloc._setWordList.add(await vocBloc._getAllWords());
    
    return vocBloc;
  }

  final VocabularyDataRepository _vocabularyRepo;
  int _currQuizWordNum = 0;
  List<Word> _quizWords = [];
  List<Word> _quizVariants = [];
  List<Word> _allWords = [];

  /// Page number in quiz
  int get currQuizWordNum => _currQuizWordNum;
  Word get currQuizWord => _quizWords.isNotEmpty
          ? _quizWords[_currQuizWordNum-1]
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
  /// Add Word with translate in home
  StreamController<Word> _variantActionController = StreamController();
  StreamSink get checkVariant => _variantActionController.sink;

  /// Word in quiz
  final BehaviorSubject<Word> _quizWordController = BehaviorSubject();
  Stream get quizWordStream => _quizWordController.stream;
  Sink get _setQuizWord => _quizWordController.sink;

  /// isLoading
  final BehaviorSubject<bool> _isLoadingController = BehaviorSubject();
  Stream get isLoadingStream => _isLoadingController.stream;
  Sink get _setIsLoading => _isLoadingController.sink;


  Future<List<Word>> _updateWordListControll() async {
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

  Future<void> _onStartGenerateQuizWords() async {
    // if (_allWords.isEmpty) {
    //   _allWords = await _vocabularyRepo.getAllWords();
    // }

    // final bool _result = await _vocabularyRepo.insertWord(
    //     word: wordWithTranslate['word'],
    //     translateList: [wordWithTranslate['translate']],
    //   );
    // if (_result) {
    //   _setWordList.add(await _vocabularyRepo.getAllWords());
    // }
  }

  Future<void> _checkVariant(Word word) async {
    // final bool _result = await _vocabularyRepo.insertWord(
    //     word: wordWithTranslate['word'],
    //     translateList: [wordWithTranslate['translate']],
    //   );
    // if (_result) {
    //   _setWordList.add(await _vocabularyRepo.getAllWords());
    // }
  }

  Future<void> _nextQuizWord() async {
    // _setQuizWord = await _vocabularyRepo;

    // if (_result) {
    //   _setWordList.add(await _vocabularyRepo.getAllWords());
    // }
    // _currQuizWordNum++;
  }

  Future<bool> deleteLastWord() async {
    print('$_allWords');
    bool _result = true;
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




  double calculateResult() { return 42; }

  Future<void> _deleteRecords() async {
    await _vocabularyRepo.deleteRecords();
    _setWordList.add(null);
    print('All records are deleted');
  }

  void dispose() {
    _newWordActionController.close();
    _variantActionController.close();
  }
}

import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/db/word_dao.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
import 'package:vocabulary_quiz/domain/model/vocabulary.dart';


class VocabularyFillingUp {
  static Future<bool> checkForEmpty() async {
    WordDao wordDao = locator<WordDao>();

    Map<String, dynamic> response = await wordDao.getAllWords();
    return response['status'];
  }

  static Future<bool> fillingUp() async {
    int primaryKey;
    // final bool _isEmpty = await VocabularyFillingUp.checkForEmpty();
    // if (!_isEmpty) {
    //   print('Vocabulary is already filled');
    //   result = true
    //   return result;
    // }
    WordDao wordDao = locator<WordDao>();
    List<Word> wordList = VocabularyFillingUp.testSet.wordList;

    for (Word _word in wordList) {
      primaryKey = await wordDao.insertWord(_word);
    }
    return primaryKey != null && primaryKey != 0;
  }


  static Vocabulary testSet = Vocabulary(
    wordList: [
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cat',
        translateList: ['кошка', 'кот'],
        imagePath: 'assets/cat_and_flower.png',
        isPassed: false,
        doesSelectedOnce: false,
      ),
    ],
  );
}

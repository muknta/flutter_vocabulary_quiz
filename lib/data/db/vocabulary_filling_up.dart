import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
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
    bool _result;
    // final bool _isEmpty = await VocabularyFillingUp.checkForEmpty();
    // if (!_isEmpty) {
    //   print('Vocabulary is already filled');
    //   result = true
    //   return result;
    // }
    WordDao wordDao = locator<WordDao>();
    List<Word> wordList = VocabularyFillingUp.testSet.wordList;

    for (Word _word in wordList) {
      _result = await wordDao.insertWord(_word);
    }
    return _result;
  }


  static Vocabulary testSet = Vocabulary(
    wordList: [
      Word(
        word: 'cat',
        translateList: ['кошка', 'котовасия'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'dog',
        translateList: ['собакен', 'пёс'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'frog',
        translateList: ['квакуха', 'лягушатник'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'stoun',
        translateList: ['хэндж', 'камень'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'house',
        translateList: ['дом', 'домушник'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'flower',
        translateList: ['цветок', 'цветочичечек'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'green',
        translateList: ['зелень', 'зелёная'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'tower',
        translateList: ['мост', 'мостишка'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'cycle',
        translateList: ['круг'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
      Word(
        word: 'triangle',
        translateList: ['треугольник'],
        imagePath: Config.defaultImageLocalPath,
        isPassed: false,
        doesSelectedOnce: false,
      ),
    ],
  );
}

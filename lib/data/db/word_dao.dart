import 'package:sembast/sembast.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/data/db/sembast_db.dart';
import 'package:vocabulary_quiz/data/mapper/word_mapper.dart';
// import 'package:vocabulary_quiz/data/mapper/vocabulary_mapper.dart';
import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
import 'exceptions.dart';


class WordDao {
  final _wordFolder = intMapStoreFactory.store(Config.sembastFolderName);
  // final _wordFolder = StoreRef<String, dynamic>.main();

  Database get _db => locator<Database>();



  Future<int> insertWord(Word word) async {
    try {
      // await _wordFolder.add(_db, WordMapper.toJson(word));
      // print('Word inserted');

      // return true;

      Database db = _db;
      await db.transaction((txn) async {
        // Add the object, get the auto incremented id
        final int key = await _wordFolder.add(txn, WordMapper.toJson(word));
        print('key - $key');
        word.primaryKey = key;
        // Set the Id in our object
        await _wordFolder.update(txn, {'primary_key': key});
      });
      return word.primaryKey;
    } on InsertingException {
      print('InsertingException');
    }
    return 0;
  }

  Future<bool> updateWord({
    @required Word oldWord,
    @required Word newWord,
  }) async {
    try {
      final finder = Finder(filter: Filter.byKey(oldWord.primaryKey));
      await _wordFolder.update(
        _db,
        WordMapper.toJson(newWord),
        finder: finder,
      );
      print('Word updated');

      return true;
    } on UpdatingException {
      print('UpdatingException');
    }
    return false;
  }

  Future<bool> deleteWord(Word word) async {
    try {
      print('$word, ${word.word}, ${word.primaryKey}');
      final finder = Finder(filter: Filter.byKey(word.primaryKey));
      final int _result = await _wordFolder.delete(_db, finder: finder);
      print('Word deleted - $_result');

      return _result != 0;
    } on DeletingException {
      print('DeletingException');
    }
    return false;
  }

  Future<List<Word>> boolFilterWords({
    bool isPassed = false,
    bool doesSelectedOnce = false,
  }) async {
    List<Word> wordList = [];

    try {
      final finder = Finder(filter: Filter.and([
        Filter.equals('is_passed', isPassed),
        Filter.equals('does_selected_once', doesSelectedOnce),
      ]));
      final recordSnapshot = await _wordFolder.find(_db, finder: finder);

      wordList = recordSnapshot.map((snapshot) =>
            WordMapper.fromJson(snapshot.value),
      ).toList();
      
      print('$recordSnapshot');

    } on ReadingException {
      print('ReadingException');
    }
    return wordList;
  }

  Future<Map<String, dynamic>> getAllWords() async {
    List<Word> wordList = [];
    bool result = false;

    try {
      final recordSnapshot = await _wordFolder.find(_db);
      
      wordList = recordSnapshot.map((snapshot) {
        final Word word = WordMapper.fromJson(snapshot.value);
        return word;
      }).toList();

      result = true;
    } on ReadingException {
      print('ReadingException');
    }
    return {
      'result': result,
      'data': wordList,
    };
  }

  Future<void> deleteRecords() async {
    await _wordFolder.delete(_db);
  }
}
